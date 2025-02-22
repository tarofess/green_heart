import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const deletePostImage = functions.firestore
    .document('post/{postId}')
    .onDelete(async (snap, context) => {
        const deletedData = snap.data();
        if (!deletedData) {
            console.log('削除されたドキュメントのデータが存在しません');
            return null;
        }

        // postドキュメント内のimageUrlsに保存されたダウンロードURLを取得
        const imageUrls: string[] = deletedData.imageUrls || [];
        const bucket = admin.storage().bucket();

        const deletePromises = imageUrls.map(async (imageUrl) => {
            // ダウンロードURLからファイルパスを抽出
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

        await Promise.all(deletePromises);
        console.log(`postID ${context.params.postId} に紐づく画像を全て削除しました`);
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
            const filePath = decodeURIComponent(match[1]);
            return filePath;
        }
        return null;
    } catch (error) {
        console.error('URLの解析に失敗しました:', downloadUrl, error);
        return null;
    }
}

