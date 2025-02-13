import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/presentation/page/comment_page.dart';
import 'package:green_heart/domain/util/date_util.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/presentation/dialog/confirmation_dialog.dart';
import 'package:green_heart/presentation/dialog/error_dialog.dart';
import 'package:green_heart/presentation/dialog/report_dialog.dart';
import 'package:green_heart/presentation/widget/loading_overlay.dart';
import 'package:green_heart/application/di/like_di.dart';
import 'package:green_heart/application/di/report_di.dart';
import 'package:green_heart/presentation/widget/user_empty_image.dart';
import 'package:green_heart/presentation/widget/user_firebase_image.dart';
import 'package:green_heart/domain/type/result.dart';
import 'package:green_heart/application/state/comment_page_notifier.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/application/state/profile_notifier.dart';

class PostCard extends ConsumerWidget {
  PostCard({super.key, required this.post, this.uidInPreviosPage});

  final Post post;
  final FocusNode focusNode = FocusNode();
  final String? uidInPreviosPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2.r,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(context, ref),
            SizedBox(height: 16.h),
            _buildTextContent(),
            SizedBox(height: 16.h),
            _buildImage(post.imageUrls),
            SizedBox(height: 8.h),
            _buildActionButtons(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        GestureDetector(
            child: post.userImage == null
                ? const UserEmptyImage(radius: 24)
                : UserFirebaseImage(
                    imageUrl: post.userImage,
                    radius: 48,
                  ),
            onTap: () {
              final uid = ref.watch(authStateProvider).value?.uid;
              if (post.uid != uid && uidInPreviosPage != post.uid) {
                context.push('/user', extra: {'uid': post.uid});
              }
            }),
        SizedBox(width: 8.h),
        Expanded(
          child: Text(
            post.userName,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildTextContent() {
    return post.content.isEmpty ? const SizedBox.shrink() : Text(post.content);
  }

  Widget _buildImage(List<String> postImages) {
    return postImages.isNotEmpty
        ? SizedBox(
            height: 240.r,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: postImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(6.w),
                  child: GestureDetector(
                    onTap: () {
                      _showFullScreenImage(context, postImages[index]);
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: CachedNetworkImage(
                            width: 240.w,
                            height: 240.h,
                            key: ValueKey(postImages[index]),
                            imageUrl: postImages[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    final myUid = ref.watch(authStateProvider).value?.uid;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildLikeWidget(context, ref),
            SizedBox(width: 16.w),
            _buildCommentWidget(context, ref),
            SizedBox(width: 24.w),
            post.uid == myUid
                ? _buildDeletePostButton(context, ref, myUid)
                : _buildReportButton(context, ref),
          ],
        ),
        Text(
          DateUtil.formatPostTime(post.releaseDate),
          style: TextStyle(fontSize: 12.sp, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildLikeWidget(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      child: Row(
        children: [
          Icon(
            size: 24.r,
            post.isLiked ? Icons.favorite : Icons.favorite_border,
            color: post.isLiked ? Colors.red : null,
          ),
          SizedBox(width: 8.w),
          Text(
            post.likeCount.toString(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      onTap: () async {
        final uid = ref.read(authStateProvider).value?.uid;
        final userName = ref.watch(profileNotifierProvider).value?.name;
        final userImage = ref.watch(profileNotifierProvider).value?.imageUrl;

        if (uid == null || userName == null) return;

        final result = await LoadingOverlay.of(
          context,
          backgroundColor: Colors.white10,
        ).during(
          () => ref.read(likeToggleUsecaseProvider).execute(
                post,
                uid,
                userName,
                userImage,
              ),
        );

        switch (result) {
          case Success():
            break;
          case Failure(message: final message):
            if (context.mounted) {
              showErrorDialog(
                context: context,
                title: 'いいねエラー',
                content: message,
              );
            }
        }
      },
    );
  }

  Widget _buildCommentWidget(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      child: Row(
        children: [
          Icon(
            Icons.comment_outlined,
            size: 24.r,
          ),
          SizedBox(width: 8.w),
          Text(
            post.commentCount.toString(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      onTap: () async {
        final result = await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.r),
            ),
          ),
          builder: (BuildContext context) {
            return DraggableScrollableSheet(
              initialChildSize: 0.9,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                  child: CommentPage(
                    post: post,
                    focusNode: focusNode,
                  ),
                );
              },
            );
          },
        );

        if (result == null) {
          ref.read(commentPageNotifierProvider.notifier).cancelReply();
        }
      },
    );
  }

  Widget _buildDeletePostButton(
    BuildContext context,
    WidgetRef ref,
    String? uid,
  ) {
    return GestureDetector(
      child: Icon(
        Icons.delete_outlined,
        size: 24.r,
      ),
      onTap: () async {
        if (uid == null) return;

        final isConfirmed = await showConfirmationDialog(
          context: context,
          title: '投稿の削除',
          content: 'この投稿を削除しますか？',
          positiveButtonText: '削除',
          negativeButtonText: 'キャンセル',
        );
        if (!isConfirmed) return;

        if (context.mounted) {
          final result = await LoadingOverlay.of(
            context,
            backgroundColor: Colors.white10,
          ).during(
            () => ref.read(postDeleteUsecaseProvider).execute(post, uid),
          );

          switch (result) {
            case Success():
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('投稿を削除しました。')),
                );
              }
              break;
            case Failure(message: final message):
              if (context.mounted) {
                showErrorDialog(
                  context: context,
                  title: '削除エラー',
                  content: message,
                );
              }
              break;
          }
        }
      },
    );
  }

  Widget _buildReportButton(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      child: Icon(
        Icons.flag_outlined,
        size: 24.r,
      ),
      onTap: () async {
        final reportText = await showReportDialog(context);
        if (reportText == null) return;

        final uid = ref.watch(authStateProvider).value?.uid;
        if (uid == null) return;

        if (context.mounted) {
          final result = await LoadingOverlay.of(
            context,
            backgroundColor: Colors.white10,
          ).during(
            () => ref.read(reportAddUsecaseProvider).execute(
                  uid,
                  reportText,
                  reportedPostId: post.id,
                  reportedCommentId: null,
                  reportedUserId: null,
                ),
          );

          switch (result) {
            case Success():
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('投稿を通報しました。'),
                  ),
                );
              }
            case Failure(message: final message):
              if (context.mounted) {
                showErrorDialog(
                  context: context,
                  title: '通報エラー',
                  content: message,
                );
              }
              break;
          }
        }
      },
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 1.0,
          minChildSize: 0.5,
          maxChildSize: 1.0,
          builder: (_, controller) {
            return Container(
              color: Colors.black,
              child: Stack(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return InteractiveViewer(
                        panEnabled: true,
                        boundaryMargin: EdgeInsets.all(20.w),
                        minScale: 0.5,
                        maxScale: 4,
                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.contain,
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 10.h,
                    left: 0.w,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 23.r,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
