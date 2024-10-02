import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:green_heart/infrastructure/get_it.dart';
import 'package:green_heart/infrastructure/service/firebase_auth_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends ConsumerWidget {
  final FirebaseAuthService _authService = getIt<FirebaseAuthService>();

  LoginPage({super.key});

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
                await _authService.signInWithGoogle(context: context);
              },
            ),
            SignInButton(
              Buttons.Apple,
              text: "Appleでログイン",
              onPressed: () async {
                await _authService.signInWithApple(context: context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
