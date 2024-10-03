import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_heart/application/state/auth_provider.dart';
import 'package:green_heart/application/state/app_initialization_provider.dart';
import 'package:green_heart/presentation/page/initialization_failure_page.dart';
import 'package:green_heart/presentation/page/login_page.dart';
import 'package:green_heart/presentation/page/home_page.dart';
import 'package:green_heart/presentation/theme/default_theme.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: createDefaultTheme(),
      home: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          final initializeApp = ref.watch(appInitializationProvider);
          return initializeApp.when(
            data: (_) {
              return StreamBuilder(
                stream: ref.watch(authRepositoryProvider).authStateChanges,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return HomePage();
                  } else {
                    return LoginPage();
                  }
                },
              );
            },
            loading: () {
              return const Scaffold(body: LoadingIndicator());
            },
            error: (e, _) {
              return InitializationFailurePage(
                error: e,
                retry: () => ref.refresh(appInitializationProvider),
              );
            },
            skipLoadingOnRefresh: false,
          );
        },
      ),
    );
  }
}
