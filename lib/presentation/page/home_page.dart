import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/auth_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('ホーム'), actions: [
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () async {
            await ref.read(signOutUseCaseProvider).execute();
          },
        ),
      ]),
      body: Container(),
    );
  }
}
