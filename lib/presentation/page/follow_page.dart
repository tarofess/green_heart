import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/presentation/widget/user_firebase_image.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/presentation/widget/user_empty_image.dart';
import 'package:green_heart/application/state/follow_notifier.dart';
import 'package:green_heart/application/state/follower_notifier.dart';
import 'package:green_heart/presentation/widget/async_error_widget.dart';

class FollowPage extends ConsumerWidget {
  const FollowPage({super.key, required this.followType, required this.uid});

  final FollowType followType;
  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followState = followType == FollowType.follow
        ? ref.watch(followNotifierProvider(uid))
        : ref.watch(followerNotifierProvider(uid));

    return Scaffold(
      appBar: AppBar(
        title: followType == FollowType.follower
            ? Text('フォロワー', style: TextStyle(fontSize: 21.sp))
            : Text('フォロー中', style: TextStyle(fontSize: 21.sp)),
        toolbarHeight: 58.h,
      ),
      body: followState.when(
        data: (follows) => SafeArea(
          child: follows.isEmpty
              ? Center(
                  child: Text(
                    followType == FollowType.follower
                        ? 'フォロワーはいません'
                        : 'フォロー中のユーザーはいません',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    followType == FollowType.follow
                        // ignore: unused_result
                        ? ref.refresh(followNotifierProvider(uid))
                        // ignore: unused_result
                        : ref.refresh(followerNotifierProvider(uid));
                  },
                  child: ListView.builder(
                    itemCount: follows.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: follows[index].userImage == null
                            ? const UserEmptyImage(radius: 21)
                            : UserFirebaseImage(
                                imageUrl: follows[index].userImage,
                                radius: 42,
                              ),
                        title: Text(
                          follows[index].userName,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        onTap: () {
                          final uid = ref.watch(authStateProvider).value?.uid;
                          if (uid != follows[index].uid) {
                            context.push(
                              '/user',
                              extra: {'uid': follows[index].uid},
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AsyncErrorWidget(
          error: e,
          retry: () => {
            followType == FollowType.follow
                // ignore: unused_result
                ? ref.refresh(followNotifierProvider(uid))
                // ignore: unused_result
                : ref.refresh(followerNotifierProvider(uid)),
          },
        ),
      ),
    );
  }
}

enum FollowType {
  follower,
  follow,
}
