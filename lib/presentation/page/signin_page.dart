import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_heart/application/state/auth_provider.dart';
import 'package:green_heart/presentation/dialog/error_dialog.dart';
import 'package:green_heart/presentation/widget/loading_overlay.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
                  buildGoogleSignInButton(context, ref),
                  SizedBox(height: 16.r),
                  buildAppleSignInButton(context, ref),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGoogleSignInButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(left: 32.r, right: 32.r),
      child: GoogleAuthButton(
        text: 'Googleアカウントで続ける',
        style: AuthButtonStyle(
          width: double.infinity,
          height: 50.r,
          textStyle: TextStyle(
            fontSize: 16.sp,
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

  Widget buildAppleSignInButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(left: 32.r, right: 32.r),
      child: AppleAuthButton(
        text: 'Appleアカウントで続ける',
        style: AuthButtonStyle(
          width: double.infinity,
          height: 50.r,
          buttonColor: Colors.black,
          iconBackground: Colors.black,
          iconColor: Colors.white,
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
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
