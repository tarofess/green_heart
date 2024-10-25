import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/domain/type/comment_data.dart';

class CommentNotifier extends FamilyAsyncNotifier<List<CommentData>, String> {
  @override
  Future<List<CommentData>> build(String arg) async {
    final comments = await ref.read(commentGetUsecaseProvider).execute(arg);
    final commentDataList = <CommentData>[];
    for (final comment in comments) {
      final profile = await ref.read(profileGetUsecaseProvider).execute(
            comment.uid,
          );
      commentDataList.add(CommentData(
        comment: comment,
        profile: profile,
      ));
    }
    return commentDataList;
  }

  Future<void> addComment(Comment newComment) async {
    final userProfile =
        await ref.read(profileGetUsecaseProvider).execute(newComment.uid);
    final newCommentData = CommentData(
      comment: newComment,
      profile: userProfile,
    );
    state = AsyncValue.data([newCommentData, ...state.value ?? []]);
  }

  Future<void> deleteComment(String commentId) async {
    await ref.read(commentDeleteUsecaseProvider).execute(commentId);

    state = AsyncValue.data(state.value?.where((commentData) {
          return commentData.comment.id != commentId;
        }).toList() ??
        []);
  }
}

final commentNotifierProvider =
    AsyncNotifierProviderFamily<CommentNotifier, List<CommentData>, String>(
        CommentNotifier.new);
