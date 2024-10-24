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
import 'package:green_heart/presentation/page/post_page.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/presentation/page/account_deleted_page.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/application/state/account_notifier.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  ref.listen<AsyncValue<User?>>(authStateProvider, (previous, next) async {
    if (next.value != null) {
      try {
        await ref.read(fcmTokenSaveUsecaeProvider).execute(next.value!.uid);
        await ref.read(profileNotifierProvider.notifier).build();
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
        routes: [
          GoRoute(
            path: 'post',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return CustomTransitionPage(
                child: const PostPage(),
                transitionDuration: const Duration(milliseconds: 800),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(0.0, 1.0);
                  var end = Offset.zero;
                  var curve = Curves.fastLinearToSlowEaseIn;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                      position: offsetAnimation, child: child);
                },
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/profile_edit',
        builder: (context, state) {
          final Map<String, dynamic>? extra =
              state.extra as Map<String, dynamic>?;
          final profile = extra?['profile'] as Profile?;
          return ProfileEditPage(profile: profile);
        },
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
      GoRoute(
        path: '/account_deleted',
        builder: (context, state) => const AccountDeletedPage(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = authState.value != null;
      final profileState = ref.read(profileNotifierProvider);
      final isProfileLoaded = profileState is AsyncData;
      final profile = isProfileLoaded ? profileState.value : null;
      final accountState = ref.read(accountNotifierProvider);

      if (!accountState.isActive) {
        return '/account_deleted';
      }

      if (!isLoggedIn && state.matchedLocation != '/signin') {
        return '/signin';
      }

      if (isLoggedIn && !isProfileLoaded) {
        return null;
      }

      if (isLoggedIn && isProfileLoaded && profile == null) {
        return '/profile_edit';
      }
      return null;
    },
  );
});
