import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

const db = admin.firestore();

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
                    deletePromises.push(bucket.file(filePath).delete().catch(err => {
                        console.error(`Error deleting profile image (${filePath}):`, err);
                    }));
                }
            }
        }

        // 2. ユーザーが投稿した投稿ドキュメントの削除
        // ※投稿ドキュメント削除時に recursiveDeletePost が起動し、画像やサブコレクションも自動削除される
        const postsSnapshot = await db.collection('post')
            .where('uid', '==', uid)
            .get();
        console.log(`Found ${postsSnapshot.size} posts by uid: ${uid}`);
        postsSnapshot.forEach((doc) => {
            deletePromises.push(doc.ref.delete());
        });

        // 3. Firestore上のその他の関連データ削除処理

        // 3-1. プロフィールドキュメントとそのサブコレクション（follow, follower, block, notification, notificationSetting）の削除
        console.log(`Deleting profile and its subcollections for uid: ${uid}`);
        deletePromises.push(db.recursiveDelete(profileRef));

        // 3-2. 他ユーザーの投稿内サブコレクション(like)で、ユーザーがいいねしたデータの削除
        const likesSnapshot = await db.collectionGroup('like')
            .where('uid', '==', uid)
            .get();
        console.log(`Found ${likesSnapshot.size} like documents by uid: ${uid}`);
        likesSnapshot.forEach((doc) => {
            deletePromises.push(doc.ref.delete());
        });

        // 3-3. 他ユーザーの投稿内サブコレクション(comment)で、ユーザーが投稿したコメントの削除
        const commentsSnapshot = await db.collectionGroup('comment')
            .where('uid', '==', uid)
            .get();
        console.log(`Found ${commentsSnapshot.size} comment documents by uid: ${uid}`);
        commentsSnapshot.forEach((doc) => {
            deletePromises.push(doc.ref.delete());
        });

        // 3-4. 他ユーザーのprofileのサブコレクション(follow)で、ユーザーをフォローしているデータの削除
        const followSnapshot = await db.collectionGroup('follow')
            .where('uid', '==', uid)
            .get();
        console.log(`Found ${followSnapshot.size} follow documents referencing uid: ${uid}`);
        followSnapshot.forEach((doc) => {
            deletePromises.push(doc.ref.delete());
        });

        // 3-5. 他ユーザーのprofileのサブコレクション(follower)で、ユーザーにフォローされているデータの削除
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
