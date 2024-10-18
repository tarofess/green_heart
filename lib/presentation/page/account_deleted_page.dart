import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:green_heart/application/state/delete_account_state_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
                Text('またのご利用お待ちしています。', style: TextStyle(fontSize: 18.sp)),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 120.sp,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  ref.read(deleteAccountStateProvider.notifier).state = false;
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
