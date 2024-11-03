import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/account_state_notifier.dart';

class AccountDeletedPage extends ConsumerWidget {
  const AccountDeletedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('アカウントを削除しました。', style: TextStyle(fontSize: 18.sp)),
                SizedBox(height: 20.sp),
                Text('ご利用ありがとうございました。', style: TextStyle(fontSize: 18.sp)),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 120.h,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  ref
                      .read(accountStateNotifierProvider.notifier)
                      .setAccountDeletedState(false);
                  ref
                      .read(accountStateNotifierProvider.notifier)
                      .setRegisteredState(false);
                  context.go('/');
                },
                child: Text('閉じる', style: TextStyle(fontSize: 18.sp)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
