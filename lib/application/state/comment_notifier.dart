import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/domain/type/comment_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CommentNotifier extends FamilyAsyncNotifier<List<CommentData>, String> {
  @override
  Future<List<CommentData>> build(String arg) async {
    final comments = await ref.read(commentGetUsecaseProvider).execute(arg);
    List<CommentData> commentDataList = [];
    for (final comment in comments) {
      final userProfile =
          await ref.read(profileGetUsecaseProvider).execute(comment.uid);
      commentDataList.add(CommentData(
        comment: comment,
        userProfile: userProfile,
      ));
    }
    return commentDataList;
  }

  Future<void> addComment(Comment newComment) async {
    final userProfile =
        await ref.read(profileGetUsecaseProvider).execute(newComment.uid);
    final newCommentData = CommentData(
      comment: newComment,
      userProfile: userProfile,
    );
    state = AsyncValue.data([newCommentData, ...state.value ?? []]);
  }
}

final commentNotifierProvider =
    AsyncNotifierProviderFamily<CommentNotifier, List<CommentData>, String>(
        CommentNotifier.new);
