import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/result.dart';
import 'package:green_heart/application/di/auth_di.dart';
import 'package:green_heart/presentation/widget/loading_overlay.dart';
import 'package:green_heart/presentation/page/terms_of_use_page.dart';
import 'package:green_heart/application/state/account_state_notifier.dart';

class SignInPage extends HookConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConsentChecked = useState(false);
    final isAccountDeleted =
        ref.watch(accountStateNotifierProvider).value?.isDeleted;
    final accountState = ref.watch(accountStateNotifierProvider);

    useEffect(() {
      // アカウント削除後にこの画面に遷移した時に表示する
      if (isAccountDeleted != null && isAccountDeleted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('アカウントが削除されました。ご利用ありがとうございました。'),
            ),
          );
        });
      }

      return null;
    });

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 16.h),
          _buildAppTitle(context),
          SizedBox(height: 52.h),
          _buildAppIcon(),
          accountState is AsyncLoading
              ? const SizedBox()
              : Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildConsentCheckbox(context, isConsentChecked),
                        SizedBox(height: 16.h),
                        _buildGoogleSignInButton(
                          context,
                          ref,
                          isConsentChecked.value,
                        ),
                        SizedBox(height: 16.h),
                        _buildAppleSignInButton(
                          context,
                          ref,
                          isConsentChecked.value,
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildAppTitle(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 100.h),
        child: Text(
          'グリーンハート',
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: Colors.lightGreen, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildAppIcon() {
    return Center(
      child: Image.asset(
        'assets/images/icon.png',
        width: 160.w,
        height: 160.h,
      ),
    );
  }

  Widget _buildConsentCheckbox(
    BuildContext context,
    ValueNotifier<bool> isConsentChecked,
  ) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
            value: isConsentChecked.value,
            onChanged: (value) {
              isConsentChecked.value = value ?? false;
            },
          ),
          Flexible(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  const TextSpan(text: ''),
                  TextSpan(
                    text: '利用規約',
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (BuildContext context) {
                            return DraggableScrollableSheet(
                              initialChildSize: 0.7,
                              minChildSize: 0.5,
                              maxChildSize: 0.7,
                              expand: false,
                              builder: (BuildContext context,
                                  ScrollController scrollController) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    top: 16.h,
                                    left: 8.w,
                                    right: 8.w,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20.r),
                                    ),
                                    child: const TermsOfUsePage(),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                  ),
                  const TextSpan(text: 'に同意する'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleSignInButton(
    BuildContext context,
    WidgetRef ref,
    bool isEnabled,
  ) {
    return Padding(
      padding: EdgeInsets.only(left: 30.w, right: 30.w),
      child: GoogleAuthButton(
        text: 'Googleアカウントでログイン',
        style: AuthButtonStyle(
          width: double.infinity,
          height: 50.h,
          textStyle: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: isEnabled
            ? () async {
                final result =
                    await LoadingOverlay.of(context, message: 'ログイン中').during(
                  () => ref.read(googleSignInUseCaseProvider).execute(),
                );

                switch (result) {
                  case Success():
                    break;
                  case Failure(message: final message):
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    }
                }
              }
            : null,
      ),
    );
  }

  Widget _buildAppleSignInButton(
    BuildContext context,
    WidgetRef ref,
    bool isEnabled,
  ) {
    return Padding(
      padding: EdgeInsets.only(left: 30.w, right: 30.w),
      child: AppleAuthButton(
        text: 'Appleアカウントでログイン',
        style: AuthButtonStyle(
          width: double.infinity,
          height: 50.h,
          buttonColor: isEnabled ? Colors.black : Colors.grey[300],
          iconBackground: isEnabled ? Colors.black : Colors.grey[300],
          iconColor: Colors.white,
          textStyle: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: isEnabled ? Colors.white : Colors.grey,
          ),
        ),
        onPressed: isEnabled
            ? () async {
                final result =
                    await LoadingOverlay.of(context, message: 'ログイン中').during(
                  () => ref.read(appleSignInUseCaseProvider).execute(),
                );

                switch (result) {
                  case Success():
                    break;
                  case Failure(message: final message):
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    }
                }
              }
            : null,
      ),
    );
  }
}
