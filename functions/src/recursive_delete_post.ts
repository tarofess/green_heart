import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const recursiveDeletePost = functions.firestore
    .document('post/{postId}')
    .onDelete(async (snap, context) => {
        const deletedData = snap.data();
        const { postId } = context.params;

        // ① 画像削除処理
        if (deletedData) {
            const imageUrls: string[] = deletedData.imageUrls || [];
            const bucket = admin.storage().bucket();

            const deleteImagePromises = imageUrls.map(async (imageUrl) => {
                const filePath = getFilePathFromUrl(imageUrl);
                if (!filePath) {
                    console.error('URLからファイルパスを抽出できませんでした:', imageUrl);
                    return;
                }
                try {
                    await bucket.file(filePath).delete();
                    console.log(`画像 ${filePath} を削除しました`);
                } catch (error) {
                    console.error(`画像 ${filePath} の削除に失敗しました:`, error);
                }
            });

            await Promise.all(deleteImagePromises);
            console.log(`postID ${postId} に紐づく画像を全て削除しました`);
        } else {
            console.log('削除されたドキュメントのデータが存在しません');
        }

        // ② サブコレクションの再帰削除処理
        const postRef = admin.firestore().collection('post').doc(postId);
        try {
            await admin.firestore().recursiveDelete(postRef);
            console.log(`Post ${postId} とそのサブコレクションを削除しました。`);
        } catch (error) {
            console.error('Postのサブコレクション削除エラー:', error);
        }

        return null;
    });

/**
 * ダウンロードURLからStorage上のファイルパスを抽出する関数
 * 例: "https://firebasestorage.googleapis.com/v0/b/xxx.appspot.com/o/image%2Fpost%2Fxxx.jpg?alt=media&token=..."
 *     → "image/post/xxx.jpg"
 */
function getFilePathFromUrl(downloadUrl: string): string | null {
    try {
        const url = new URL(downloadUrl);
        const match = url.pathname.match(/\/o\/(.+)/);
        if (match && match[1]) {
            return decodeURIComponent(match[1]);
        }
        return null;
    } catch (error) {
        console.error('URLの解析に失敗しました:', downloadUrl, error);
        return null;
    }
}
