import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

// いいね作成時に、親の post の likeCount を +1 する
export const onLikeCreated = functions.firestore
    .document('post/{postId}/like/{likeId}')
    .onCreate(async (snap, context) => {
        const { postId } = context.params;
        const postRef = admin.firestore().collection('post').doc(postId);
        return postRef.update({
            likeCount: admin.firestore.FieldValue.increment(1)
        });
    });

// いいね削除時に、親の post の likeCount を -1 する
export const onLikeDeleted = functions.firestore
    .document('post/{postId}/like/{likeId}')
    .onDelete(async (snap, context) => {
        const { postId } = context.params;
        const postRef = admin.firestore().collection('post').doc(postId);
        return postRef.update({
            likeCount: admin.firestore.FieldValue.increment(-1)
        });
    });