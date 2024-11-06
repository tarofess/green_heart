import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/follower_notifier.dart';
import 'package:green_heart/application/state/following_notifier.dart';
import 'package:green_heart/presentation/widget/async_error_widget.dart';
import 'package:green_heart/presentation/page/follow_page.dart';

class FollowStateWidget extends ConsumerWidget {
  const FollowStateWidget({super.key, required this.uid});

  final String? uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followerState = ref.watch(followerNotifierProvider(uid));
    final followingState = ref.watch(followingNotifierProvider(uid));

    return followerState.when(
      data: (follower) {
        return followingState.when(
          data: (following) {
            return SizedBox(
              height: 120.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.push('/follow', extra: {
                            'follows': followerState.value,
                            'followType': FollowType.follower,
                          });
                        },
                        child: Column(
                          children: [
                            const Text('フォロワー'),
                            Text(
                              follower.length.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push('/follow', extra: {
                            'follows': followingState.value,
                            'followType': FollowType.following,
                          });
                        },
                        child: Column(
                          children: [
                            const Text('フォロー中'),
                            Text(
                              following.length.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          loading: () => const SizedBox(),
          error: (e, _) => AsyncErrorWidget(
            error: e,
            retry: () => ref.refresh(followingNotifierProvider(uid)),
          ),
        );
      },
      loading: () => const SizedBox(),
      error: (e, _) => AsyncErrorWidget(
        error: e,
        retry: () => ref.refresh(followerNotifierProvider(uid)),
      ),
    );
  }
}
