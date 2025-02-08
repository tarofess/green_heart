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
    bool isTablet = MediaQuery.of(context).size.width >= 600;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: const SizedBox.shrink(),
          toolbarHeight: 0.h,
          bottom: TabBar(
            labelStyle: isTablet ? TextStyle(fontSize: 13.sp) : null,
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
