import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

const db = admin.firestore();

/**
 * コメントが削除されたとき、その子コメントを再帰的に削除する関数
 */
export const deleteReplyComment = functions.firestore
    .document('post/{postId}/comment/{commentId}')
    .onDelete(async (snap, context) => {
        const { postId, commentId } = context.params;
        console.log(`Deleted comment ${commentId} in post ${postId}`);

        try {
            // 削除されたコメントの子コメントを削除する
            await deleteChildComments(postId, commentId);
            console.log(`All child comments of ${commentId} have been deleted.`);
        } catch (error) {
            console.error(`Error deleting child comments for ${commentId}:`, error);
        }
    });

/**
 * 指定した投稿内で、親コメントIDが指定のIDと一致するコメントを取得し、
 * そのコメントの子コメントも再帰的に削除する関数
 * @param postId 投稿ID
 * @param parentCommentId 削除対象の親コメントID
 */
async function deleteChildComments(postId: string, parentCommentId: string): Promise<void> {
    // 該当投稿内のコメントサブコレクションから、parentCommentIdが一致するコメントを取得
    const childCommentsSnapshot = await db
        .collection('post')
        .doc(postId)
        .collection('comment')
        .where('parentCommentId', '==', parentCommentId)
        .get();

    if (childCommentsSnapshot.empty) {
        return;
    }

    // 各子コメントについて、まずその子コメント（下位のコメント）を再帰的に削除し、
    // その後自身を削除する
    const deletePromises = childCommentsSnapshot.docs.map(async (doc) => {
        console.log(`Deleting child comment: ${doc.id}`);
        // 再帰的に子コメントを削除
        await deleteChildComments(postId, doc.id);
        // 子コメントを削除
        return doc.ref.delete();
    });

    await Promise.all(deletePromises);
}
