import 'package:flutter/material.dart';
import 'package:green_heart/presentation/router/router.dart';
import 'package:green_heart/presentation/theme/default_theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: createDefaultTheme(),
      routerConfig: router,
    );
  }
}
