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
            ? const Text('フォロワー')
            : const Text('フォロー中'),
      ),
      body: followState.when(
        data: (follows) => SafeArea(
          child: follows.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Center(
                    child: Text(
                      followType == FollowType.follower
                          ? 'フォロワーはいません'
                          : 'フォロー中のユーザーはいません',
                    ),
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
                        title: Text(follows[index].userName),
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
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (e, stackTrace) {
          return AsyncErrorWidget(
            error: e,
            retry: () => {
              followType == FollowType.follow
                  // ignore: unused_result
                  ? ref.refresh(followNotifierProvider(uid))
                  // ignore: unused_result
                  : ref.refresh(followerNotifierProvider(uid)),
            },
          );
        },
      ),
    );
  }
}

enum FollowType {
  follower,
  follow,
}
