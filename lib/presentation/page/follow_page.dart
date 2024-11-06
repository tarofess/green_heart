import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/follow_data.dart';
import 'package:green_heart/presentation/widget/user_firebase_image.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';

class FollowPage extends ConsumerWidget {
  const FollowPage({
    super.key,
    required this.follows,
    required this.followType,
  });

  final List<FollowData> follows;
  final FollowType followType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: followType == FollowType.follower
            ? Text('フォロワー', style: TextStyle(fontSize: 21.sp))
            : Text('フォロー中', style: TextStyle(fontSize: 21.sp)),
        toolbarHeight: 58.h,
      ),
      body: follows.isEmpty
          ? Center(
              child: Text(
                followType == FollowType.follower
                    ? 'フォロワーはいません'
                    : 'フォロー中のユーザーはいません',
                style: TextStyle(fontSize: 16.sp),
              ),
            )
          : ListView.builder(
              itemCount: follows.length,
              itemBuilder: (context, index) {
                final followData = follows[index];
                return ListTile(
                  leading: UserFirebaseImage(
                    imageUrl: followData.profile?.imageUrl ?? '',
                    radius: 48,
                  ),
                  title: Text(
                    followData.profile?.name ?? '',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  onTap: () {
                    final uid = ref.watch(authStateProvider).value?.uid;
                    if (uid != followData.profile?.uid) {
                      context.push(
                        '/user',
                        extra: {'uid': followData.profile?.uid},
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}

enum FollowType {
  follower,
  following,
}
