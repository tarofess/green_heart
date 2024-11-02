import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/block_notifier.dart';
import 'package:green_heart/presentation/page/error_page.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';

class BlockListPage extends ConsumerWidget {
  const BlockListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockState = ref.watch(blockNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('ブロックリスト')),
      body: blockState.when(
        data: (blockList) {
          if (blockList.isEmpty) {
            return const Center(child: Text('ブロックしているユーザーはいません'));
          }
          return ListView.builder(
            itemCount: blockList.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 24.r,
                  backgroundImage: CachedNetworkImageProvider(
                    blockList[index].profile?.imageUrl ?? '',
                  ),
                ),
                title: Text(blockList[index].profile?.name ?? ''),
                onTap: () {
                  context.push(
                    '/user',
                    extra: {'uid': blockList[index].profile?.uid},
                  );
                },
              );
            },
          );
        },
        loading: () {
          return const LoadingIndicator();
        },
        error: (e, _) {
          return ErrorPage(
            error: e,
            retry: () => ref.refresh(blockNotifierProvider),
          );
        },
      ),
    );
  }
}
