import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

/**
 * 【いいね時の通知】
 * Aさんが投稿（post/{postId}）にいいね（post/{postId}/like/{likeId}）した時、
 * 投稿の所有者（Bさん）の profile/{Bさんのuid}/notification に通知データを追加する
 */
export const addNotificationOnLike = functions.firestore
    .document('post/{postId}/like/{likeId}')
    .onCreate(async (snap, context) => {
        console.log('addNotificationOnLike triggered.');
        const likeData = snap.data();
        if (!likeData) {
            console.log('No like data found. Exiting function.');
            return;
        }
        console.log('Received like data:', likeData);

        // Aさんの情報
        const senderUid = likeData.uid;
        const senderUserName = likeData.userName;
        const senderUserImage = likeData.userImage || null;

        // 対象の投稿ID
        const postId = context.params.postId;
        console.log(`Fetching post document for postId: ${postId}`);
        const postSnap = await admin.firestore().collection('post').doc(postId).get();
        if (!postSnap.exists) {
            console.log(`Post document with id ${postId} does not exist. Exiting function.`);
            return;
        }
        const postData = postSnap.data();
        if (!postData || !postData.uid) {
            console.log('Post data is missing or does not contain uid. Exiting function.');
            return;
        }
        const receiverUid = postData.uid;
        console.log(`Notification receiver uid: ${receiverUid}`);

        // 自分の投稿にいいねした場合は通知を作らない
        if (senderUid === receiverUid) {
            console.log('Sender and receiver are the same. Exiting function.');
            return;
        }

        // 【通知設定チェック】いいね通知が有効か確認する
        const settingSnapshot = await admin.firestore()
            .collection('profile')
            .doc(receiverUid)
            .collection('notificationSetting')
            .get();
        let likeEnabled = false;
        settingSnapshot.forEach(doc => {
            const data = doc.data();
            if (data.likeSetting) {
                likeEnabled = true;
            }
        });
        if (!likeEnabled) {
            console.log('Like notifications are disabled in settings. Exiting function.');
            return;
        }

        const postContent = postData.content;
        console.log(`Notification post content: ${postContent}`);

        // 通知データ作成
        const notification = createNotificationData('like', receiverUid, senderUid, senderUserName, senderUserImage, postId, postContent);
        console.log('Notification data to be added:', notification);

        // Bさんの通知サブコレクションに追加
        const notificationRef = admin.firestore().collection('profile').doc(receiverUid).collection('notification');
        try {
            const docRef = await notificationRef.add(notification);
            await docRef.update({ id: docRef.id });
            console.log(`Notification successfully added with id: ${docRef.id}`);
        } catch (error) {
            console.error('Error while adding notification:', error);
        }
        return;
    });

/**
 * 【コメント時の通知】
 * Aさんが投稿（post/{postId}）にコメント（post/{postId}/comment/{commentId}）した時、
 * 投稿の所有者（Bさん）の profile/{Bさんのuid}/notification に通知データを追加する
 */
export const addNotificationOnComment = functions.firestore
    .document('post/{postId}/comment/{commentId}')
    .onCreate(async (snap, context) => {
        console.log('addNotificationOnComment triggered.');
        const commentData = snap.data();
        if (!commentData) {
            console.log('No comment data found. Exiting function.');
            return;
        }
        console.log('Received comment data:', commentData);

        // コメントしたユーザー（例：BさんまたはAさん）の情報
        const senderUid = commentData.uid;
        const senderUserName = commentData.userName;
        const senderUserImage = commentData.userImage || null;

        // 対象の投稿IDを取得
        const postId = context.params.postId;
        console.log(`Fetching post document for postId: ${postId}`);
        const postSnap = await admin.firestore().collection('post').doc(postId).get();
        if (!postSnap.exists) {
            console.log(`Post document with id ${postId} does not exist. Exiting function.`);
            return;
        }
        const postData = postSnap.data();
        if (!postData || !postData.uid) {
            console.log('Post data is missing or does not contain uid. Exiting function.');
            return;
        }

        let receiverUid: string;
        let notificationType = 'comment'; // 初期値はコメント通知
        // replyTargetUid が存在すれば返信なので、通知先はコメント相手とし、typeを 'reply' に変更
        if (commentData.parentCommentId && commentData.replyTargetUid) {
            receiverUid = commentData.replyTargetUid;
            notificationType = 'reply';
            console.log(`This is a reply. Notification receiver (replyTargetUid): ${receiverUid}`);
        } else {
            // それ以外はトップレベルコメント→通知先は投稿者
            receiverUid = postData.uid;
            console.log(`This is a top-level comment. Notification receiver (post owner): ${receiverUid}`);
        }

        // 自分自身へのコメント／返信の場合は通知を作らない
        if (senderUid === receiverUid) {
            console.log('Sender and receiver are the same. Exiting function.');
            return;
        }

        // 【通知設定チェック】コメント通知が有効か確認する
        const settingSnapshot = await admin.firestore()
            .collection('profile')
            .doc(receiverUid)
            .collection('notificationSetting')
            .get();
        let commentEnabled = false;
        settingSnapshot.forEach(doc => {
            const data = doc.data();
            if (data.commentSetting) {
                commentEnabled = true;
            }
        });
        if (!commentEnabled) {
            console.log('Comment notifications are disabled in settings. Exiting function.');
            return;
        }

        const postContent = postData.content;
        console.log(`Notification post content: ${postContent}`);

        // 通知データ作成（type は 'comment' または 'reply'）
        const notification = createNotificationData(
            notificationType,
            receiverUid,
            senderUid,
            senderUserName,
            senderUserImage,
            postId,
            postContent
        );
        console.log('Notification data to be added:', notification);

        // 通知データを受け取るユーザーのサブコレクションに追加
        const notificationRef = admin.firestore()
            .collection('profile')
            .doc(receiverUid)
            .collection('notification');
        try {
            const docRef = await notificationRef.add(notification);
            await docRef.update({ id: docRef.id });
            console.log(`Notification successfully added with id: ${docRef.id}`);
        } catch (error) {
            console.error('Error while adding notification:', error);
        }
        return;
    });


/**
 * 【フォロー時の通知】
 * Aさんが Bさんをフォロー（profile/{Bさんのuid}/follower/{followerId}）した時、
 * Bさんの profile/{Bさんのuid}/notification に通知データを追加する
 */
export const addNotificationOnFollow = functions.firestore
    .document('profile/{userId}/follower/{followerId}')
    .onCreate(async (snap, context) => {
        console.log('addNotificationOnFollow triggered.');
        const followData = snap.data();
        if (!followData) {
            console.log('No follow data found. Exiting function.');
            return;
        }
        console.log('Received follow data:', followData);

        // Bさんの uid はドキュメントパスから取得
        const receiverUid = context.params.userId;
        const senderUid = followData.uid;
        const senderUserName = followData.userName;
        const senderUserImage = followData.userImage || null;
        console.log(`Notification receiver uid: ${receiverUid}`);

        // 【通知設定チェック】フォロー通知が有効か確認する
        const settingSnapshot = await admin.firestore()
            .collection('profile')
            .doc(receiverUid)
            .collection('notificationSetting')
            .get();
        let followEnabled = false;
        settingSnapshot.forEach(doc => {
            const data = doc.data();
            if (data.followerSetting) {
                followEnabled = true;
            }
        });
        if (!followEnabled) {
            console.log('Follow notifications are disabled in settings. Exiting function.');
            return;
        }

        // フォローの場合は投稿IDは関係ないので null をセット
        const notification = createNotificationData('follow', receiverUid, senderUid, senderUserName, senderUserImage, null, null);
        console.log('Notification data to be added:', notification);

        // Bさんの通知サブコレクションに追加
        const notificationRef = admin.firestore().collection('profile').doc(receiverUid).collection('notification');
        try {
            const docRef = await notificationRef.add(notification);
            await docRef.update({ id: docRef.id });
            console.log(`Notification successfully added with id: ${docRef.id}`);
        } catch (error) {
            console.error('Error while adding notification:', error);
        }
        return;
    });

/**
 * 通知データの作成用ヘルパー関数
 * @param type 通知の種類 ('like' | 'comment' | 'follow')
 * @param receiverUid 通知を受け取るユーザー（Bさん）の uid
 * @param senderUid アクションを実行したユーザー（Aさん）の uid
 * @param senderUserName Aさんのユーザー名
 * @param senderUserImage Aさんのユーザー画像（存在しなければ null）
 * @param postId 関連する投稿ID。フォローの場合は null とする
 * @param postContent 関連する投稿内容。フォローの場合は null とする
 * @returns 通知データオブジェクト
 */
function createNotificationData(
    type: string,
    receiverUid: string,
    senderUid: string,
    senderUserName: string,
    senderUserImage: string | null,
    postId: string | null,
    postContent: String | null,
) {
    return {
        type,
        isRead: false,
        postId,
        postContent,
        receiverUid,
        senderUid,
        senderUserName,
        senderUserImage,
        createdAt: new Date().toISOString(),
    };
}
