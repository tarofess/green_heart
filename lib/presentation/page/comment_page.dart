import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/comment_data.dart';
import 'package:green_heart/application/state/comment_notifier.dart';
import 'package:green_heart/presentation/page/error_page.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/presentation/widget/comment_card.dart';
import 'package:green_heart/application/state/comment_page_notifier.dart';
import 'package:green_heart/presentation/dialog/error_dialog.dart';
import 'package:green_heart/application/state/comment_page_state.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';

class CommentPage extends HookConsumerWidget {
  const CommentPage({super.key, required this.postId, required this.focusNode});

  final String postId;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentState = ref.watch(commentNotifierProvider(postId));
    final commentPageState = ref.watch(commentPageNotifierProvider);
    final commentTextController = useTextEditingController();

    useEffect(() {
      return ref.read(commentPageNotifierProvider.notifier).cancelReply;
    }, const []);

    return Scaffold(
      appBar: AppBar(title: const Text('コメント')),
      body: commentState.when(
        data: (comments) {
          return Column(
            children: [
              Expanded(
                child: comments.isEmpty
                    ? _buildEmptyCommentMessage()
                    : _buildComment(ref, comments, focusNode),
              ),
              const Divider(height: 1),
              Padding(
                padding: EdgeInsets.only(top: 8.r, bottom: 8.r, left: 16.r),
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
          return const LoadingIndicator();
        },
        error: (e, ststackTrace) {
          return ErrorPage(
            error: e,
            retry: () => ref.refresh(commentNotifierProvider(postId)),
          );
        },
      ),
    );
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
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.sp),
            Text(
              '最初のコメントを追加してみよう。',
              style: TextStyle(
                fontSize: 14.sp,
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
      itemCount: comments.length,
      itemBuilder: (context, index) {
        return CommentCard(
          key: ValueKey(comments[index].comment.id),
          commentData: comments[index],
          postId: postId,
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
                focusNode: focusNode,
                controller: commentTextController,
                decoration: InputDecoration(
                  hintText:
                      commentPageState.isReplying ? '返信中...' : 'コメントを入力...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
                ),
              ),
            ),
            IconButton(
                icon: Icon(Icons.send, size: 24.sp),
                onPressed: () async {
                  try {
                    final uid = ref.watch(authStateProvider).value?.uid;
                    if (uid == null || commentTextController.text.isEmpty) {
                      return;
                    }

                    await ref
                        .read(commentNotifierProvider(postId).notifier)
                        .addComment(
                          uid,
                          postId,
                          commentTextController.text,
                          ref.read(commentPageNotifierProvider).parentCommentId,
                        );
                    clearReply(ref, commentTextController);
                  } catch (e) {
                    if (context.mounted) {
                      showErrorDialog(
                        context: context,
                        title: 'コメントの投稿に失敗しました',
                        content: e.toString(),
                      );
                    }
                  }
                }),
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
      padding: EdgeInsets.only(bottom: 8.r),
      child: Row(
        children: [
          Text(
            '${commentPageState.parentUserName}に返信中...',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
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
