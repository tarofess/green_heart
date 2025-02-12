import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

// post が削除されたときに、その post に紐づく like, comment も削除する
export const recursiveDeletePost = functions.firestore
    .document('post/{postId}')
    .onDelete(async (snap, context) => {
        const { postId } = context.params as { postId: string };
        const postRef = admin.firestore().collection('post').doc(postId);

        try {
            await admin.firestore().recursiveDelete(postRef);
            console.log(`Post ${postId} とそのサブコレクションを削除しました。`);
        } catch (error) {
            console.error('Postのサブコレクション削除エラー:', error);
        }
    });