import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountRegistrationPage extends ConsumerWidget {
  const AccountRegistrationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント登録'),
      ),
      body: Container(),
    );
  }
}
