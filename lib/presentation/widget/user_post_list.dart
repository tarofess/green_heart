import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/user_post_notifier.dart';
import 'package:green_heart/application/state/user_post_scroll_state_notifier.dart';
import 'package:green_heart/presentation/widget/async_error_widget.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/presentation/widget/post_card.dart';

class UserPostList extends HookConsumerWidget {
  const UserPostList({
    super.key,
    required this.uid,
    required this.scrollController,
  });

  final String? uid;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPostState = ref.watch(userPostNotifierProvider(uid));
    final isLoadingMore = useState(false);

    useEffect(() {
      void onScroll() async {
        if (scrollController.position.pixels ==
                scrollController.position.maxScrollExtent &&
            !isLoadingMore.value) {
          isLoadingMore.value = true;
          try {
            await ref
                .read(userPostNotifierProvider(uid).notifier)
                .loadMore(uid);
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

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(userPostScrollStateNotifierProvider(uid).notifier).reset();
      });

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    return userPostState.when(
      data: (userPosts) {
        return userPosts.isEmpty
            ? Center(
                child: Text(
                  '投稿はまだありません',
                  style: TextStyle(fontSize: 16.sp),
                ),
              )
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: scrollController,
                itemCount: userPosts.length + 1,
                itemBuilder: (context, index) {
                  if (index < userPosts.length) {
                    return Padding(
                      padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 0.h),
                      child: PostCard(
                        key: ValueKey(userPosts[index]),
                        postData: userPosts[index],
                        uidInPreviosPage: uid,
                      ),
                    );
                  } else {
                    return ref
                            .read(userPostScrollStateNotifierProvider(uid))
                            .hasMore
                        ? Padding(
                            padding: EdgeInsets.all(8.w),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : const SizedBox.shrink();
                  }
                },
              );
      },
      loading: () => const Center(
        child: LoadingIndicator(
          message: '読み込み中',
          backgroundColor: Colors.white10,
        ),
      ),
      error: (error, stackTrace) => AsyncErrorWidget(
        error: error,
        retry: () => ref.refresh(userPostNotifierProvider(uid)),
      ),
    );
  }
}
