import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

// コメント作成時に、親の post の commentCount を +1 する
export const onCommentCreated = functions.firestore
    .document('post/{postId}/comment/{commentId}')
    .onCreate(async (snap, context) => {
        const { postId } = context.params;
        const postRef = admin.firestore().collection('post').doc(postId);
        return postRef.update({
            commentCount: admin.firestore.FieldValue.increment(1)
        });
    });

// コメント削除時に、親の post の commentCount を -1 する
export const onCommentDeleted = functions.firestore
    .document('post/{postId}/comment/{commentId}')
    .onDelete(async (snap, context) => {
        const { postId } = context.params;
        const postRef = admin.firestore().collection('post').doc(postId);
        return postRef.update({
            commentCount: admin.firestore.FieldValue.increment(-1)
        });
    });
