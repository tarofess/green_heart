import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/presentation/widget/async_error_widget.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/presentation/widget/post_card.dart';
import 'package:green_heart/application/state/timeline_notifier.dart';
import 'package:green_heart/presentation/widget/post_search.dart';
import 'package:green_heart/application/state/timeline_scroll_state_notifier.dart';
import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/domain/type/result.dart';

class TimelinePage extends HookConsumerWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineState = ref.watch(timelineNotifierProvider);
    final isLoadingMore = useState(false);
    final scrollController = useScrollController();

    useEffect(() {
      // 無限スクロールのための読み込み処理
      void onScroll() async {
        if (isLoadingMore.value) return;

        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          isLoadingMore.value = true;

          final result =
              await ref.read(timelineLoadMoreUsecaseProvider).execute();

          if (result is Failure && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('データの読み込みに失敗しました。再度お試しください。')),
            );
          }

          isLoadingMore.value = false;
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        title: const Text('みんなの投稿'),
        leadingWidth: 42.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: Image.asset('assets/images/sakura.png'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, size: 24.r),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PostSearch(),
              );
            },
          )
        ],
      ),
      body: timelineState.when(
        data: (timeline) {
          return RefreshIndicator(
            onRefresh: () async {
              final result =
                  await ref.read(timelineRefreshUsecaseProvider).execute();

              if (result is Failure && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('データの読み込みに失敗しました。再度お試しください。')),
                );
              }
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: scrollController,
              itemCount: timeline.length + 1,
              itemBuilder: (context, index) {
                if (index < timeline.length) {
                  return Padding(
                    padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 4.h),
                    child: PostCard(
                      key: ValueKey(timeline[index].id),
                      post: timeline[index],
                    ),
                  );
                } else {
                  return ref.read(timelineScrollStateNotifierProvider).hasMore
                      ? Padding(
                          padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : const SizedBox.shrink();
                }
              },
            ),
          );
        },
        error: (e, stackTrace) {
          return AsyncErrorWidget(
            error: e,
            retry: () => ref.refresh(timelineNotifierProvider),
          );
        },
        loading: () {
          return const LoadingIndicator(message: '読み込み中');
        },
      ),
    );
  }
}
