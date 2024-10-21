import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/post.dart';

class PostCard extends ConsumerWidget {
  const PostCard({super.key, required this.post, this.profile});

  final Post post;
  final Profile? profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfoArea(),
            SizedBox(height: 16.r),
            _buildTextContentArea(),
            SizedBox(height: 16.r),
            _buildImageArea(post.imageUrls),
            SizedBox(height: 8.r),
            _buildLikeAndCommentArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoArea() {
    return Row(
      children: [
        CircleAvatar(
          radius: 24.r,
          backgroundImage: CachedNetworkImageProvider(profile?.imageUrl ?? ''),
        ),
        SizedBox(width: 8.r),
        Text(
          profile?.name ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTextContentArea() {
    return post.content.isEmpty ? const SizedBox() : Text(post.content);
  }

  Widget _buildImageArea(List<String> postImages) {
    return postImages.isNotEmpty
        ? SizedBox(
            height: 240.r,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: postImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(6.r),
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
                );
              },
            ),
          )
        : const SizedBox();
  }

  Widget _buildLikeAndCommentArea() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Icon(Icons.favorite_border),
        SizedBox(width: 8.r),
        Text(post.likeCount.toString()),
        SizedBox(width: 16.r),
        const Icon(Icons.comment_outlined),
        SizedBox(width: 8.r),
        Text(post.commentCount.toString()),
      ],
    );
  }
}
