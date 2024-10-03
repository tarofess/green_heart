import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_heart/application/state/app_initialization_provider.dart';
import 'package:green_heart/application/state/auth_provider.dart';
import 'package:green_heart/presentation/page/home_page.dart';
import 'package:green_heart/presentation/page/error_page.dart';
import 'package:green_heart/presentation/page/login_page.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RoutePage extends ConsumerWidget {
  const RoutePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        final initializeApp = ref.watch(appInitializationProvider);
        return initializeApp.when(
          data: (_) {
            return StreamBuilder(
              stream: ref.watch(authRepositoryProvider).authStateChanges,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const HomePage();
                } else {
                  return const LoginPage();
                }
              },
            );
          },
          loading: () {
            return const Scaffold(body: LoadingIndicator());
          },
          error: (e, _) {
            return ErrorPage(
              error: e,
              retry: () => ref.refresh(appInitializationProvider),
            );
          },
          skipLoadingOnRefresh: false,
        );
      },
    );
  }
}
