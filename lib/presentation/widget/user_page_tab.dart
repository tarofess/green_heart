import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:green_heart/presentation/widget/user_diary.dart';
import 'package:green_heart/presentation/widget/user_post_list.dart';

class UserPageTab extends StatelessWidget {
  const UserPageTab({
    super.key,
    required this.uid,
    required this.scrollController,
  });

  final String? uid;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
            labelStyle: TextStyle(fontSize: 14.sp),
            tabs: const [
              Tab(text: '日誌'),
              Tab(text: '投稿一覧'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UserDiary(uid: uid),
            UserPostList(uid: uid, scrollController: scrollController),
          ],
        ),
      ),
    );
  }
}