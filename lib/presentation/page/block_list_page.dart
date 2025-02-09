import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/block_notifier.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/presentation/widget/user_empty_image.dart';
import 'package:green_heart/presentation/widget/user_firebase_image.dart';
import 'package:green_heart/presentation/widget/async_error_widget.dart';

class BlockListPage extends ConsumerWidget {
  const BlockListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockState = ref.watch(blockNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('ブロックリスト')),
      body: SafeArea(
        child: blockState.when(
          data: (blockList) {
            if (blockList.isEmpty) {
              return const Center(child: Text('ブロックしているユーザーはいません'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                // ignore: unused_result
                ref.refresh(blockNotifierProvider);
              },
              child: ListView.builder(
                itemCount: blockList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    key: ValueKey(blockList[index].uid),
                    leading: blockList[index].userImage == null
                        ? const UserEmptyImage(radius: 21)
                        : UserFirebaseImage(
                            imageUrl: blockList[index].userImage,
                            radius: 42,
                          ),
                    title: Text(blockList[index].userName),
                    onTap: () {
                      context.push(
                        '/user',
                        extra: {'uid': blockList[index].targetUid},
                      );
                    },
                  );
                },
              ),
            );
          },
          loading: () {
            return const LoadingIndicator(
              message: 'ブロックリスト取得中',
              backgroundColor: Colors.white10,
            );
          },
          error: (e, stackTrace) {
            return AsyncErrorWidget(
              error: e,
              retry: () => ref.refresh(blockNotifierProvider),
            );
          },
        ),
      ),
    );
  }
}
