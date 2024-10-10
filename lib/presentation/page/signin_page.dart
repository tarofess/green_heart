import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/auth_provider.dart';
import 'package:green_heart/presentation/dialog/error_dialog.dart';
import 'package:green_heart/presentation/widget/loading_overlay.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGoogleSignInButton(context, ref),
                  SizedBox(height: 16.r),
                  _buildAppleSignInButton(context, ref),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(left: 30.r, right: 30.r),
      child: GoogleAuthButton(
        text: 'Googleアカウントでログイン',
        style: AuthButtonStyle(
          width: double.infinity,
          height: 50.r,
          textStyle: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () async {
          try {
            await LoadingOverlay.of(context).during(
              () => ref.read(googleSignInUseCaseProvider).execute(),
            );
          } catch (e) {
            if (context.mounted) {
              showErrorDialog(
                context: context,
                title: 'サインインエラー',
                content: e.toString(),
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildAppleSignInButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(left: 30.r, right: 30.r),
      child: AppleAuthButton(
        text: 'Appleアカウントでログイン',
        style: AuthButtonStyle(
          width: double.infinity,
          height: 50.r,
          buttonColor: Colors.black,
          iconBackground: Colors.black,
          iconColor: Colors.white,
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () async {
          try {
            await LoadingOverlay.of(context).during(
              () => ref.read(appleSignInUseCaseProvider).execute(),
            );
          } catch (e) {
            if (context.mounted) {
              showErrorDialog(
                context: context,
                title: 'サインインエラー',
                content: e.toString(),
              );
            }
          }
        },
      ),
    );
  }
}
