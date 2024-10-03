import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SignInButton(
              Buttons.Google,
              text: "Googleでログイン",
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
            SignInButton(
              Buttons.Apple,
              text: "Appleでログイン",
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
    );
  }
}
