import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/follower_notifier.dart';
import 'package:green_heart/application/state/follow_notifier.dart';
import 'package:green_heart/presentation/widget/async_error_widget.dart';
import 'package:green_heart/presentation/page/follow_page.dart';

class FollowStateWidget extends ConsumerWidget {
  const FollowStateWidget({super.key, required this.uid});

  final String? uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followerState = ref.watch(followerNotifierProvider(uid));
    final followState = ref.watch(followNotifierProvider(uid));

    return followerState.when(
      data: (follower) {
        return followState.when(
          data: (follow) {
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
                            'followType': FollowType.follower,
                            'uid': uid,
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              'フォロワー',
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                            ),
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
                            'followType': FollowType.follow,
                            'uid': uid,
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              'フォロー中',
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              follow.length.toString(),
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
            retry: () => ref.refresh(followNotifierProvider(uid)),
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
