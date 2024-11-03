import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/presentation/page/error_page.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/presentation/widget/post_card.dart';
import 'package:green_heart/application/state/timeline_notifier.dart';
import 'package:green_heart/presentation/widget/post_search.dart';

class TimelinePage extends ConsumerStatefulWidget {
  const TimelinePage({super.key});

  @override
  ConsumerState<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends ConsumerState<TimelinePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_isLoadingMore) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    await ref.read(timelineNotifierProvider.notifier).loadMore();

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final timelineState = ref.watch(timelineNotifierProvider);

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
              controller: _scrollController,
              itemCount: timeline.length + 1,
              itemBuilder: (context, index) {
                if (index == timeline.length) {
                  return _isLoadingMore
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox.shrink();
                }
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
