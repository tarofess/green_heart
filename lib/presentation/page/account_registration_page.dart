import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:green_heart/infrastructure/get_it.dart';
import 'package:green_heart/infrastructure/service/firebase_auth_service.dart';
import 'package:green_heart/presentation/page/home_page.dart';
import 'package:green_heart/presentation/service/navigation_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountRegistrationPage extends ConsumerWidget {
  final FirebaseAuthService _authService = getIt<FirebaseAuthService>();
  final NavigationService _navigationService = getIt<NavigationService>();

  AccountRegistrationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ログイン'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SignInButton(
              Buttons.Google,
              text: "Googleでログイン",
              onPressed: () async {
                User? user =
                    await _authService.signInWithGoogle(context: context);
                if (user != null) {
                  _navigationService.pushReplacement(context, HomePage());
                }
              },
            ),
            SignInButton(
              Buttons.Apple,
              text: "Appleでログイン",
              onPressed: () async {
                User? user =
                    await _authService.signInWithApple(context: context);
                if (user != null) {
                  _navigationService.pushReplacement(context, HomePage());
                }
              },
            ),
            SignInButton(
              Buttons.Facebook,
              text: "Facebookでログイン",
              onPressed: () async {
                // User? user = await _authService.signUpWithEmail(email, password);
              },
            ),
          ],
        ),
      ),
    );
  }
}
