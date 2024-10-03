import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:go_router/go_router.dart';
import 'package:green_heart/application/state/auth_provider.dart';
import 'package:green_heart/presentation/dialog/error_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログイン'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GoogleAuthButton(
                    text: 'Googleでログイン',
                    style: AuthButtonStyle(
                      width: 260.r,
                      height: 50.r,
                    ),
                    onPressed: () async {
                      try {
                        await ref.read(googleSignInUseCaseProvider).execute();
                      } catch (e) {
                        if (context.mounted) {
                          showErrorDialog(
                            context: context,
                            title: 'ログインエラー',
                            content: e.toString(),
                          );
                        }
                      }
                    },
                  ),
                  SizedBox(height: 16.r),
                  AppleAuthButton(
                    text: 'Appleでログイン',
                    style: AuthButtonStyle(
                      width: 260.r,
                      height: 50.r,
                    ),
                    onPressed: () async {
                      try {
                        await ref.read(appleSignInUseCaseProvider).execute();
                      } catch (e) {
                        if (context.mounted) {
                          showErrorDialog(
                            context: context,
                            title: 'ログインエラー',
                            content: e.toString(),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 32.r),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text('新しいアカウントを作成'),
              onPressed: () {
                context.go('singup');
              },
            ),
          ),
        ],
      ),
    );
  }
}
