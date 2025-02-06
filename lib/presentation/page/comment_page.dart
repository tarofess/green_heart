import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/comment_data.dart';
import 'package:green_heart/application/state/comment_notifier.dart';
import 'package:green_heart/presentation/widget/async_error_widget.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/presentation/widget/comment_card.dart';
import 'package:green_heart/application/state/comment_page_notifier.dart';
import 'package:green_heart/presentation/dialog/error_dialog.dart';
import 'package:green_heart/domain/type/comment_page_state.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/presentation/widget/loading_overlay.dart';
import 'package:green_heart/application/di/comment_di.dart';
import 'package:green_heart/domain/type/result.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/domain/type/post.dart';

class CommentPage extends HookConsumerWidget {
  const CommentPage({
    super.key,
    required this.post,
    required this.focusNode,
  });

  final Post post;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentState = ref.watch(commentNotifierProvider(post.id));
    final commentPageState = ref.watch(commentPageNotifierProvider);
    final commentTextController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'コメント',
          style: TextStyle(fontSize: 21.sp),
        ),
        toolbarHeight: 58.h,
      ),
      body: SafeArea(
        child: commentState.when(
          data: (comments) {
            return Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => _refreshComments(ref),
                    child: comments.isEmpty
                        ? _buildEmptyCommentMessage()
                        : _buildComment(ref, comments, focusNode),
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: EdgeInsets.only(top: 8.h, bottom: 8.h, left: 16.w),
                  child: _buildInputForm(
                    context,
                    ref,
                    commentPageState,
                    commentTextController,
                  ),
                ),
              ],
            );
          },
          loading: () {
            return const LoadingIndicator(
              message: 'コメント取得中',
              backgroundColor: Colors.white10,
            );
          },
          error: (e, stackTrace) {
            return AsyncErrorWidget(
              error: e,
              retry: () => ref.refresh(
                commentNotifierProvider(post.id),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _refreshComments(WidgetRef ref) async {
    // ignore: unused_result
    ref.refresh(commentNotifierProvider(post.id));
  }

  Widget _buildEmptyCommentMessage() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'コメントはまだありません',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.sp),
            Text(
              '最初のコメントを追加してみよう',
              style: TextStyle(
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComment(
    WidgetRef ref,
    List<CommentData> comments,
    FocusNode focusNode,
  ) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: comments.length,
      itemBuilder: (context, index) {
        return CommentCard(
          key: ValueKey(comments[index].comment.id),
          commentData: comments[index],
          post: post,
          focusNode: focusNode,
        );
      },
    );
  }

  Widget _buildInputForm(
    BuildContext context,
    WidgetRef ref,
    CommentPageState commentPageState,
    TextEditingController commentTextController,
  ) {
    return Column(
      children: [
        commentPageState.isReplying
            ? _buildReplyingMessage(ref, commentPageState)
            : const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextField(
                style: TextStyle(fontSize: 16.sp),
                focusNode: focusNode,
                controller: commentTextController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText:
                      commentPageState.isReplying ? '返信中...' : 'コメントを入力...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, size: 24.sp),
              onPressed: () async {
                final uid = ref.watch(authStateProvider).value?.uid;
                if (uid == null || commentTextController.text.isEmpty) {
                  return;
                }

                final result = await LoadingOverlay.of(
                  context,
                  backgroundColor: Colors.white10,
                ).during(() async {
                  final profile = ref.watch(profileNotifierProvider).value;
                  return ref.read(commentAddUsecaseProvider).execute(
                        uid,
                        post,
                        commentTextController.text,
                        commentPageState.parentCommentId,
                        profile?.name ?? '',
                        profile?.imageUrl,
                        ref.read(commentNotifierProvider(post.id).notifier),
                      );
                });

                switch (result) {
                  case Success():
                    break;
                  case Failure(message: final message):
                    if (context.mounted) {
                      showErrorDialog(
                        context: context,
                        title: 'コメントの投稿に失敗しました',
                        content: message,
                      );
                    }
                }

                clearReply(ref, commentTextController);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReplyingMessage(
    WidgetRef ref,
    CommentPageState commentPageState,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.w),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${commentPageState.parentUserName}に返信中...',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 24.sp),
            onPressed: () {
              ref.read(commentPageNotifierProvider.notifier).cancelReply();
            },
          ),
        ],
      ),
    );
  }

  void clearReply(WidgetRef ref, TextEditingController commentTextController) {
    commentTextController.clear();
    focusNode.unfocus();
    ref.read(commentPageNotifierProvider.notifier).cancelReply();
  }
}
