import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:green_heart/presentation/page/error_page.dart';
import 'package:green_heart/presentation/router/router.dart';
import 'package:green_heart/presentation/theme/default_theme.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/application/di/init_di.dart';
import 'package:green_heart/application/state/account_state_notifier.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initializeApp = ref.watch(appInitProvider);

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return initializeApp.when(
          data: (_) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: createDefaultTheme(),
            routerConfig: ref.watch(routerProvider),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('ja', 'JP')],
            locale: const Locale('ja', 'JP'),
          ),
          loading: () => const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: LoadingIndicator(),
            ),
          ),
          error: (e, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            home: ErrorPage(
              error: e,
              retry: () => ref.refresh(appInitProvider),
            ),
          ),
        );
      },
    );
  }
}

final appInitProvider = FutureProvider.autoDispose((ref) async {
  await ref.read(firebaseInitUsecaseProvider).execute();
  await ref.read(accountStateNotifierProvider.notifier).checkIfFirstTimeUser();
});
