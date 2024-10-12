import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/presentation/page/tab_page.dart';
import 'package:green_heart/presentation/page/signin_page.dart';
import 'package:green_heart/presentation/page/profile_edit_page.dart';
import 'package:green_heart/presentation/page/account_page.dart';
import 'package:green_heart/presentation/page/app_info_page.dart';
import 'package:green_heart/presentation/page/settings_page.dart';
import 'package:green_heart/application/di/fcm_di.dart';
import 'package:green_heart/presentation/page/notification_setting_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  ref.listen<AsyncValue<User?>>(authStateProvider, (previous, next) async {
    if (next.value != null) {
      try {
        await ref.read(fcmTokenSaveUsecaeProvider).execute(next.value!.uid);
      } catch (e) {
        return;
      }
    }
  });

  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const TabPage(),
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/profile_edit',
        builder: (context, state) => ProfileEditPage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/account_info',
        builder: (context, state) => const AccountPage(),
      ),
      GoRoute(
        path: '/notification_setting',
        builder: (context, state) => const NotificationSettingPage(),
      ),
      GoRoute(
        path: '/app_info',
        builder: (context, state) {
          final Map<String, dynamic> extra =
              state.extra as Map<String, dynamic>;
          final appInfo = extra['app_info'] as String?;
          return AppInfoPage(appInfo: appInfo);
        },
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final isNotLoggedIn = authState.value == null;

      if (isNotLoggedIn && state.matchedLocation != '/signin') {
        return '/signin';
      }

      if (!isNotLoggedIn || state.matchedLocation == '/') {}

      return null;
    },
  );
});
