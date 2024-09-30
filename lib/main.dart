import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_heart/application/state/initialize_app_provider.dart';
import 'package:green_heart/infrastructure/service/firebase_auth_service.dart';
import 'package:green_heart/infrastructure/get_it.dart';
import 'package:green_heart/presentation/page/account_registration_page.dart';
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
          final initializeApp = ref.watch(initializeAppProvider);

          return initializeApp.when(
            data: (_) {
              final FirebaseAuthService authService =
                  getIt<FirebaseAuthService>();
              return StreamBuilder(
                stream: authService.authStateChanges,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return HomePage();
                  } else {
                    return AccountRegistrationPage();
                  }
                },
              );
            },
            loading: () {
              return const Scaffold(body: LoadingIndicator());
            },
            error: (e, _) {
              return ErrorScreen(
                error: e,
                retry: () => ref.refresh(initializeAppProvider),
              );
            },
            skipLoadingOnRefresh: false,
          );
        },
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final Object? error;
  final VoidCallback retry;

  const ErrorScreen({super.key, this.error, required this.retry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('アプリの初期化に失敗しました。\n再度お試しください。'),
            SizedBox(height: 16.r),
            Text(
              '$error',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.r),
            ElevatedButton(
              onPressed: retry,
              child: const Text('リトライ'),
            ),
          ],
        ),
      ),
    );
  }
}
