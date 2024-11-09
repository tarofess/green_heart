import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/post_data.dart';
import 'package:green_heart/presentation/widget/post_card.dart';

class UserDiaryDetailPage extends ConsumerWidget {
  const UserDiaryDetailPage({super.key, required this.postData});

  final PostData postData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${postData.post.releaseDate.year}年'
          '${postData.post.releaseDate.month}月'
          '${postData.post.releaseDate.day}日',
          style: TextStyle(fontSize: 21.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 0.h, bottom: 8.h, left: 8.w, right: 8.w),
        child: PostCard(postData: postData),
      ),
    );
  }
}
