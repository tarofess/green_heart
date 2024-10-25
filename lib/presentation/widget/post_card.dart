import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/presentation/page/comment_page.dart';
import 'package:green_heart/domain/util/date_util.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';
import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/domain/type/post_data.dart';

class PostCard extends ConsumerWidget {
  const PostCard({super.key, required this.postData});

  final PostData postData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(),
            SizedBox(height: 16.r),
            _buildTextContent(),
            SizedBox(height: 16.r),
            _buildImage(postData.post.imageUrls),
            SizedBox(height: 8.r),
            _buildActionButtons(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 24.r,
          backgroundImage: CachedNetworkImageProvider(
            postData.userProfile?.imageUrl ?? '',
          ),
        ),
        SizedBox(width: 8.r),
        Text(
          postData.userProfile?.name ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTextContent() {
    return postData.post.content.isEmpty
        ? const SizedBox()
        : Text(postData.post.content);
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
                  padding: EdgeInsets.all(6.r),
                  child: GestureDetector(
                    onTap: () {
                      _showFullScreenImage(context, postImages[index]);
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: CachedNetworkImage(
                            width: 240.r,
                            height: 240.r,
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
        : const SizedBox();
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildLikeWidget(ref),
            SizedBox(width: 16.r),
            _buildCommentWidget(context, ref),
            SizedBox(width: 16.r),
            _buildDeletePostButton(context, ref),
          ],
        ),
        Text(
          DateUtil.formatPostTime(postData.post.createdAt),
          style: TextStyle(fontSize: 12.sp, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildLikeWidget(WidgetRef ref) {
    return GestureDetector(
      child: Row(
        children: [
          Icon(
            postData.post.likedUserIds
                    .contains(ref.read(authStateProvider).value?.uid)
                ? Icons.favorite
                : Icons.favorite_border,
            color: postData.post.likedUserIds
                    .contains(ref.read(authStateProvider).value?.uid)
                ? Colors.red
                : null,
          ),
          SizedBox(width: 8.r),
          Text(postData.post.likedUserIds.length.toString()),
        ],
      ),
      onTap: () async {
        final uid = ref.read(authStateProvider).value?.uid;
        if (uid == null) return;

        await ref.read(likeUsecaseProvider).execute(postData.post.id, uid);
        ref.read(userPostNotifierProvider.notifier).updateLikedUserIds(
              postData.post.id,
              uid,
            );
      },
    );
  }

  Widget _buildCommentWidget(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      child: Row(
        children: [
          const Icon(Icons.comment_outlined),
          SizedBox(width: 8.r),
          Text(postData.commentCount.toString()),
        ],
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: FractionallySizedBox(
                heightFactor: 0.6,
                child: CommentPage(postId: postData.post.id),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDeletePostButton(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      child: const Icon(Icons.delete_outlined),
      onTap: () async {},
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
                        boundaryMargin: EdgeInsets.all(20.r),
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
                    top: 10.r,
                    left: 0.r,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
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
