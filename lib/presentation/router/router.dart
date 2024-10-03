import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_heart/presentation/page/home_page.dart';
import 'package:green_heart/presentation/page/login_page.dart';
import 'package:green_heart/presentation/page/route_page.dart';
import 'package:green_heart/presentation/page/signup_page.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const RoutePage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          },
        ),
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: 'signup',
          builder: (BuildContext context, GoRouterState state) {
            return const SignUpPage();
          },
        ),
      ],
    ),
  ],
);
