import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

const db = admin.firestore();

/**
 * // ドキュメントリストに対して、500 件ごとにバッチ更新を行うヘルパー関数
 * @param docs - Array of QueryDocumentSnapshots to be deleted.
 */
async function deleteNotificationBatches(
    docs: FirebaseFirestore.QueryDocumentSnapshot[]
) {
    const batches: Promise<any>[] = [];
    let batch = db.batch();
    let opCount = 0;

    for (const doc of docs) {
        batch.delete(doc.ref);
        opCount++;

        if (opCount === 500) {
            batches.push(batch.commit());
            batch = db.batch();
            opCount = 0;
        }
    }

    if (opCount > 0) {
        batches.push(batch.commit());
    }

    return Promise.all(batches);
}

/**
 * 毎週日曜日の午前0時（日本時間）に実行される scheduled function  
 * 全ユーザーの profile/{uid}/notification サブコレクションから  
 * isRead === true の通知を500件ずつ再帰的に削除します。
 */
export const deleteReadNotifications = functions.pubsub
    .schedule('0 0 * * 0')
    .timeZone('Asia/Tokyo')
    .onRun(async (context) => {
        console.log('deleteReadNotifications function started');
        try {
            const snapshot = await db
                .collectionGroup('notification')
                .where('isRead', '==', true)
                .get();

            console.log(`Found ${snapshot.size} notifications to delete`);

            if (!snapshot.empty) {
                await deleteNotificationBatches(snapshot.docs);
                console.log('Successfully deleted all read notifications');
            } else {
                console.log('No notifications to delete');
            }
        } catch (error) {
            console.error('Error deleting read notifications:', error);
        }
        return null;
    });
