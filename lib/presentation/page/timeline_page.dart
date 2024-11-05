import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/presentation/page/error_page.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/presentation/widget/post_card.dart';
import 'package:green_heart/application/state/timeline_notifier.dart';
import 'package:green_heart/presentation/widget/post_search.dart';

class TimelinePage extends HookConsumerWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineState = ref.watch(timelineNotifierProvider);
    final isLoadingMore = useState(false);
    final scrollController = useScrollController();

    useEffect(() {
      void onScroll() async {
        if (scrollController.position.extentAfter < 500 &&
            !isLoadingMore.value) {
          isLoadingMore.value = true;
          try {
            await ref.read(timelineNotifierProvider.notifier).loadMore();
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('データの読み込みに失敗しました。再試行してください。')),
              );
            }
          } finally {
            isLoadingMore.value = false;
          }
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'みんなの投稿',
          style: TextStyle(fontSize: 21.sp),
        ),
        toolbarHeight: 58.h,
        actions: [
          IconButton(
            icon: Icon(Icons.search, size: 24.r),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PostSearch(postSearchType: PostSearchType.timeline),
              );
            },
          )
        ],
      ),
      body: timelineState.when(
        data: (timeline) {
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(timelineNotifierProvider.notifier).refresh();
            },
            child: ListView.builder(
              controller: scrollController,
              itemCount: timeline.length,
              itemBuilder: (context, index) {
                return PostCard(
                  key: ValueKey(timeline[index].post.id),
                  postData: timeline[index],
                );
              },
            ),
          );
        },
        error: (e, stackTrace) {
          return ErrorPage(
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
