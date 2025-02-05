import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();
const db = admin.firestore();

// ドキュメントリストに対して、500 件ごとにバッチ更新を行うヘルパー関数
async function updateProfileBatches(
    docs: FirebaseFirestore.QueryDocumentSnapshot[],
    newData: { userName: string; userImage: string }
) {
    const batches: Promise<any>[] = [];
    let batch = db.batch();
    let opCount = 0;

    for (const doc of docs) {
        batch.update(doc.ref, newData);
        opCount++;

        // 500件に達したらコミットして、新しいバッチを作成
        if (opCount === 500) {
            batches.push(batch.commit());
            batch = db.batch();
            opCount = 0;
        }
    }
    // 残りがあればコミット
    if (opCount > 0) {
        batches.push(batch.commit());
    }

    return Promise.all(batches);
}

// Profileが更新されたときのトリガー
export const onProfileUpdate = functions.firestore
    .document('profile/{uid}') // トップレベルの profile ドキュメント
    .onUpdate(async (change, context) => {
        const beforeData = change.before.data();
        const afterData = change.after.data();

        if (!beforeData || !afterData) {
            return null;
        }

        // name と imageUrl に変更がない場合は何もしない
        if (beforeData.name === afterData.name && beforeData.imageUrl === afterData.imageUrl) {
            return null;
        }

        // 更新されたユーザーの UID と新しい値を取得
        const uid = context.params.uid;
        const newUserName = afterData.name;
        const newUserImage = afterData.imageUrl;

        const newData = {
            userName: newUserName,
            userImage: newUserImage,
        };

        const updatePromises: Promise<any>[] = [];

        // 1. トップレベルの post コレクション内のドキュメントを更新
        {
            const postsSnapshot = await db
                .collection('post')
                .where('uid', '==', uid)
                .get();

            if (!postsSnapshot.empty) {
                updatePromises.push(updateProfileBatches(postsSnapshot.docs, newData));
            }
        }

        // 2. post のサブコレクション: comment を更新
        const postSubcollections = ['comment'];
        for (const subcollection of postSubcollections) {
            const snapshot = await db
                .collectionGroup(subcollection)
                .where('uid', '==', uid)
                .get();

            if (!snapshot.empty) {
                updatePromises.push(updateProfileBatches(snapshot.docs, newData));
            }
        }

        // 3. profile のサブコレクション: block, follow, follower を更新
        const profileSubcollections = ['block', 'follow', 'follower'];
        for (const subcollection of profileSubcollections) {
            const snapshot = await db
                .collectionGroup(subcollection)
                .where('uid', '==', uid)
                .get();

            if (!snapshot.empty) {
                updatePromises.push(updateProfileBatches(snapshot.docs, newData));
            }
        }

        return Promise.all(updatePromises);
    });

// アカウント削除時に関連データを削除
export const onAccountDelete = functions.auth.user().onDelete(async (user) => {
    const uid = user.uid;
    console.log(`Authentication user deleted: ${uid}`);
    const deletePromises: Promise<any>[] = [];

    const bucket = admin.storage().bucket();

    try {
        // 1. プロフィール画像の削除
        const profileRef = db.collection('profile').doc(uid);
        const profileSnap = await profileRef.get();
        if (profileSnap.exists) {
            const profileData = profileSnap.data();
            if (profileData && profileData.imageUrl) {
                const filePath = extractFilePathFromUrl(profileData.imageUrl);
                if (filePath) {
                    console.log(`Deleting profile image file: ${filePath}`);
                    // Storage上のファイルを削除
                    deletePromises.push(bucket.file(filePath).delete().catch(err => {
                        console.error(`Error deleting profile image (${filePath}):`, err);
                    }));
                }
            }
        }

        // 2. ユーザーが投稿した画像の削除
        const postsSnapshot = await db.collection('post')
            .where('uid', '==', uid)
            .get();
        console.log(`Found ${postsSnapshot.size} posts by uid: ${uid}`);
        postsSnapshot.forEach((doc) => {
            const postData = doc.data();

            if (postData.imageUrls && Array.isArray(postData.imageUrls)) {
                postData.imageUrls.forEach((url: string) => {
                    const filePath = extractFilePathFromUrl(url);
                    if (filePath) {
                        console.log(`Deleting post image file: ${filePath}`);
                        deletePromises.push(bucket.file(filePath).delete().catch(err => {
                            console.error(`Error deleting post image (${filePath}):`, err);
                        }));
                    }
                });
            }
        });

        // 3. Firestore上の関連データ削除処理
        // 3-1. プロフィールドキュメントとそのサブコレクション（follow, follower, block, notification）の削除
        console.log(`Deleting profile and its subcollections for uid: ${uid}`);
        deletePromises.push(db.recursiveDelete(profileRef));

        // 3-2. ユーザーが投稿したpostの削除（サブコレクション like, comment も削除）
        postsSnapshot.forEach((doc) => {
            deletePromises.push(db.recursiveDelete(doc.ref));
        });

        // 3-3. 他ユーザーの投稿内サブコレクション(like)で、ユーザーがいいねしたデータの削除
        const likesSnapshot = await db.collectionGroup('like')
            .where('uid', '==', uid)
            .get();
        console.log(`Found ${likesSnapshot.size} like documents by uid: ${uid}`);
        likesSnapshot.forEach((doc) => {
            deletePromises.push(doc.ref.delete());
        });

        // 3-4. 他ユーザーの投稿内サブコレクション(comment)で、ユーザーが投稿したコメントの削除
        const commentsSnapshot = await db.collectionGroup('comment')
            .where('uid', '==', uid)
            .get();
        console.log(`Found ${commentsSnapshot.size} comment documents by uid: ${uid}`);
        commentsSnapshot.forEach((doc) => {
            deletePromises.push(doc.ref.delete());
        });

        // 3-5. 他ユーザーのprofileのサブコレクション(follow)で、ユーザーをフォローしているデータの削除
        const followSnapshot = await db.collectionGroup('follow')
            .where('uid', '==', uid)
            .get();
        console.log(`Found ${followSnapshot.size} follow documents referencing uid: ${uid}`);
        followSnapshot.forEach((doc) => {
            deletePromises.push(doc.ref.delete());
        });

        // 3-6. 他ユーザーのprofileのサブコレクション(follower)で、ユーザーにフォローされているデータの削除
        const followerSnapshot = await db.collectionGroup('follower')
            .where('uid', '==', uid)
            .get();
        console.log(`Found ${followerSnapshot.size} follower documents referencing uid: ${uid}`);
        followerSnapshot.forEach((doc) => {
            deletePromises.push(doc.ref.delete());
        });

        await Promise.all(deletePromises);
        console.log(`All related data for uid ${uid} has been deleted.`);
    } catch (error) {
        console.error(`Error deleting related data for uid ${uid}:`, error);
    }
});

// ヘルパー関数：画像URLからStorage上のファイルパスを抽出する
function extractFilePathFromUrl(url: string): string {
    const marker = '/o/';
    const markerIndex = url.indexOf(marker);
    if (markerIndex === -1) {
        return '';
    }
    const start = markerIndex + marker.length;
    const end = url.indexOf('?', start);
    const encodedPath = end === -1 ? url.substring(start) : url.substring(start, end);
    return decodeURIComponent(encodedPath);
}

