import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

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
        try {
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

            // 2. post のサブコレクション: like, comment を更新
            const postSubcollections = ['like', 'comment'];
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
        } catch (error) {
            console.error('onProfileUpdate でエラーが発生しました', error);
            return null;
        }
    });