import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/comment_data.dart';

class CommentPage extends ConsumerWidget {
  const CommentPage({super.key, required this.comments});

  final List<CommentData> comments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('コメント'),
      ),
      body: comments.isEmpty
          ? Center(
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
            )
          : ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 24.r,
                    backgroundImage: CachedNetworkImageProvider(
                      comments[index].userProfile?.imageUrl ?? '',
                    ),
                  ),
                  title: Text(
                    comments[index].userProfile?.name ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  subtitle: Text(
                    comments[index].comment.content,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                );
              },
            ),
    );
  }
}
