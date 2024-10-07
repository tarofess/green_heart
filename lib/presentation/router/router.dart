import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_heart/application/state/auth_provider.dart';
import 'package:green_heart/presentation/page/home_page.dart';
import 'package:green_heart/presentation/page/signin_page.dart';
import 'package:green_heart/presentation/page/profile_edit_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/profile_edit',
        builder: (context, state) => ProfileEditPage(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) async {
      final isNotLoggedIn = authState.value == null;

      if (isNotLoggedIn && state.matchedLocation != '/signin') {
        return '/signin';
      }

      return null;
    },
  );
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});
