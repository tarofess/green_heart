import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

// いいねが付いたときに通知を送信
export const sendPushNotificationOnLike = functions.firestore
    .document("post/{postId}/like/{likeId}")
    .onCreate(async (snapshot, context) => {
        // 1. いいねドキュメントのデータを取得
        const likeData = snapshot.data();
        if (!likeData) {
            console.log("いいねデータがありません。");
            return;
        }
        const likerUid = likeData.uid;      // いいねしたユーザーのUID
        const likerName = likeData.userName; // いいねしたユーザーの名前

        // 2. 投稿IDを取得し、投稿ドキュメントから投稿者のUIDを取得
        const { postId } = context.params;
        const postRef = admin.firestore().collection("post").doc(postId);
        const postDoc = await postRef.get();
        if (!postDoc.exists) {
            console.log("投稿が見つかりませんでした:", postId);
            return;
        }
        const postData = postDoc.data();
        const postOwnerUid = postData?.uid;
        if (!postOwnerUid) {
            console.log("投稿者のUIDが取得できませんでした。");
            return;
        }

        // 3. 自分の投稿にいいねした場合は通知を送信しない
        if (likerUid === postOwnerUid) {
            console.log("自分の投稿にいいねしたので通知は送信しません。");
            return;
        }

        // ★ ブロックチェック ★
        // 投稿者が、いいねしたユーザー（likerUid）をブロックしている場合は通知しない
        const blockSnapshot = await admin.firestore()
            .collection("profile")
            .doc(postOwnerUid)
            .collection("block")
            .where("targetUid", "==", likerUid)
            .get();
        if (!blockSnapshot.empty) {
            console.log("ブロック済みのユーザーからのいいね通知なので送信しません。");
            return;
        }

        // 4. 投稿者のFCMトークンを profile/{postOwnerUid}/notificationSetting から取得し、
        //    likeSettingがtrueのトークンのみ収集
        const tokensSnapshot = await admin.firestore()
            .collection("profile")
            .doc(postOwnerUid)
            .collection("notificationSetting")
            .get();

        if (tokensSnapshot.empty) {
            console.log("FCMトークンが見つかりませんでした:", postOwnerUid);
            return;
        }

        const tokens: string[] = [];
        tokensSnapshot.forEach(doc => {
            const tokenData = doc.data();
            // likeSettingがtrueの場合のみ通知対象とする
            if (tokenData.token && tokenData.likeSetting) {
                tokens.push(tokenData.token);
            }
        });

        if (tokens.length === 0) {
            console.log("通知設定がオフのため、送信する有効なFCMトークンがありません。");
            return;
        }

        // 5. 通知の内容を設定
        const message: admin.messaging.MulticastMessage = {
            tokens: tokens,
            notification: {
                title: "いいねが届きました！",
                body: `${likerName}さんがあなたの投稿にいいねしました！`
            }
        };

        // 6. プッシュ通知の送信
        try {
            const response = await admin.messaging().sendEachForMulticast(message);
            console.log("通知送信結果:", response);
        } catch (error) {
            console.error("通知送信エラー:", error);
        }
    });


// コメントされたときに通知を送信
export const sendPushNotificationOnComment = functions.firestore
    .document("post/{postId}/comment/{commentId}")
    .onCreate(async (snapshot, context) => {
        // 1. コメントドキュメントのデータを取得
        const commentData = snapshot.data();
        if (!commentData) {
            console.log("コメントデータがありません。");
            return;
        }
        const commenterUid = commentData.uid;      // コメントしたユーザーのUID
        const commenterName = commentData.userName;  // コメントしたユーザーの名前

        // 2. 投稿IDを取得し、投稿ドキュメントから投稿者のUIDを取得
        const { postId } = context.params;
        const postRef = admin.firestore().collection("post").doc(postId);
        const postDoc = await postRef.get();
        if (!postDoc.exists) {
            console.log("投稿が見つかりませんでした:", postId);
            return;
        }
        const postData = postDoc.data();
        const postOwnerUid = postData?.uid;
        if (!postOwnerUid) {
            console.log("投稿者のUIDが取得できませんでした。");
            return;
        }

        let receiverUid: string;
        // replyTargetUid があれば返信通知として通知先を設定
        if (commentData.parentCommentId && commentData.replyTargetUid) {
            receiverUid = commentData.replyTargetUid;
            console.log(`This is a reply. Notification receiver (replyTargetUid): ${receiverUid}`);
        } else {
            receiverUid = postOwnerUid;
            console.log(`This is a top-level comment. Notification receiver (post owner): ${receiverUid}`);
        }

        // 自分自身へのコメント／返信の場合は通知を送信しない
        if (commenterUid === receiverUid) {
            console.log("自分の投稿または自分のコメントに対してコメントしたので通知は送信しません。");
            return;
        }

        // ★ ブロックチェック ★
        // 通知先ユーザーが、コメントしたユーザー（commenterUid）をブロックしている場合は通知しない
        const blockSnapshot = await admin.firestore()
            .collection("profile")
            .doc(receiverUid)
            .collection("block")
            .where("targetUid", "==", commenterUid)
            .get();
        if (!blockSnapshot.empty) {
            console.log("ブロック済みのユーザーからのコメント通知なので送信しません。");
            return;
        }

        // 3. 通知先ユーザーのFCMトークンを profile/{receiverUid}/notificationSetting から取得
        const tokensSnapshot = await admin.firestore()
            .collection("profile")
            .doc(receiverUid)
            .collection("notificationSetting")
            .get();

        if (tokensSnapshot.empty) {
            console.log("FCMトークンが見つかりませんでした:", receiverUid);
            return;
        }

        const tokens: string[] = [];
        tokensSnapshot.forEach(doc => {
            const tokenData = doc.data();
            if (tokenData.token && tokenData.commentSetting) {
                tokens.push(tokenData.token);
            }
        });

        if (tokens.length === 0) {
            console.log("通知設定がオフのため、送信する有効なFCMトークンがありません。");
            return;
        }

        // 4. プッシュ通知の内容を設定
        const message: admin.messaging.MulticastMessage = {
            tokens: tokens,
            notification: {
                title: "コメントが届きました！",
                body: `${commenterName}さんがあなたにコメントしました！`
            }
        };

        // 5. プッシュ通知送信
        try {
            const response = await admin.messaging().sendEachForMulticast(message);
            console.log("コメント通知送信結果:", response);
        } catch (error) {
            console.error("コメント通知送信エラー:", error);
        }
    });


// フォローされたときに通知を送信
export const sendPushNotificationOnFollow = functions.firestore
    .document("profile/{userId}/follower/{followerId}")
    .onCreate(async (snapshot, context) => {
        // 1. フォロー情報のデータを取得
        const followData = snapshot.data();
        if (!followData) {
            console.log("フォロー情報がありません。");
            return;
        }
        const followerName = followData.userName; // フォローしたユーザーの名前

        // 2. フォローされたユーザーのUIDを取得（ドキュメントパスの userId）
        const { userId, followerId } = context.params;
        if (!userId) {
            console.log("フォローされたユーザーのUIDが取得できませんでした。");
            return;
        }

        // ★ ブロックチェック ★
        // 通知先ユーザーが、フォローしたユーザー（followerId）をブロックしている場合は通知しない
        const blockSnapshot = await admin.firestore()
            .collection("profile")
            .doc(userId)
            .collection("block")
            .where("targetUid", "==", followerId)
            .get();
        if (!blockSnapshot.empty) {
            console.log("ブロック済みのユーザーからのフォロー通知なので送信しません。");
            return;
        }

        // 3. フォローされたユーザーのFCMトークンを profile/{userId}/notificationSetting から取得し、
        //    followerSettingがtrueのトークンのみ収集
        const tokensSnapshot = await admin.firestore()
            .collection("profile")
            .doc(userId)
            .collection("notificationSetting")
            .get();

        if (tokensSnapshot.empty) {
            console.log("FCMトークンが見つかりませんでした:", userId);
            return;
        }

        const tokens: string[] = [];
        tokensSnapshot.forEach(doc => {
            const tokenData = doc.data();
            // followerSettingがtrueの場合のみ通知対象とする
            if (tokenData.token && tokenData.followerSetting) {
                tokens.push(tokenData.token);
            }
        });

        if (tokens.length === 0) {
            console.log("通知設定がオフのため、送信する有効なFCMトークンがありません。");
            return;
        }

        // 4. 通知の内容を設定
        const message: admin.messaging.MulticastMessage = {
            tokens: tokens,
            notification: {
                title: "フォローされました！",
                body: `${followerName}さんがあなたをフォローしました！`
            }
        };

        // 5. プッシュ通知の送信
        try {
            const response = await admin.messaging().sendEachForMulticast(message);
            console.log("フォロー通知送信結果:", response);
        } catch (error) {
            console.error("フォロー通知送信エラー:", error);
        }
    });
