import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      appBar: AppBar(
        title: Text(
          'ブロックリスト',
          style: TextStyle(fontSize: 21.sp),
        ),
        toolbarHeight: 58.h,
      ),
      body: SafeArea(
        child: blockState.when(
          data: (blockList) {
            if (blockList.isEmpty) {
              return Center(
                child: Text(
                  'ブロックしているユーザーはいません',
                  style: TextStyle(fontSize: 16.sp),
                ),
              );
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
                    title: Text(
                      blockList[index].userName,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    onTap: () {
                      context.push(
                        '/user',
                        extra: {'uid': blockList[index].uid},
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
          error: (e, _) {
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
