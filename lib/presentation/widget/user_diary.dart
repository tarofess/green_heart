import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:green_heart/application/state/user_post_notifier.dart';
import 'package:green_heart/presentation/widget/async_error_widget.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/application/state/user_post_scroll_state_notifier.dart';
import 'package:green_heart/domain/type/result.dart';

class UserDiary extends HookConsumerWidget {
  const UserDiary({super.key, required this.uid});

  final String? uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPostState = ref.watch(userPostNotifierProvider(uid));
    final selectedDay = useState(DateTime.now());
    final focusedDay = useState(DateTime.now());

    return userPostState.when(
      data: (userPosts) {
        return RefreshIndicator(
          onRefresh: () async {
            final result = await ref
                .read(userPostRefreshUsecaseProvider)
                .execute(
                  uid,
                  ref.read(userPostNotifierProvider(uid).notifier),
                  ref.read(userPostScrollStateNotifierProvider(uid).notifier),
                );

            if (result is Failure && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('データの読み込みに失敗しました。再度お試しください。')),
              );
            }
          },
          child: _buildCalendar(
            context,
            ref,
            userPosts,
            selectedDay,
            focusedDay,
          ),
        );
      },
      loading: () {
        return const LoadingIndicator(
          message: null,
          backgroundColor: Colors.white10,
        );
      },
      error: (error, stackTrace) {
        return AsyncErrorWidget(
          error: error,
          retry: () => ref.refresh(userPostNotifierProvider(uid)),
        );
      },
    );
  }

  Widget _buildCalendar(
    BuildContext context,
    WidgetRef ref,
    List<Post> userPosts,
    ValueNotifier<DateTime> selectedDay,
    ValueNotifier<DateTime> focusedDay,
  ) {
    return SingleChildScrollView(
      child: TableCalendar(
        availableGestures: AvailableGestures.none,
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2124, 12, 31),
        focusedDay: focusedDay.value,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleTextStyle: TextStyle(fontSize: 16.sp),
        ),
        locale: 'ja_JP',
        rowHeight: 52.h,
        eventLoader: (day) {
          return userPosts
              .where((post) =>
                  post.releaseDate.year == day.year &&
                  post.releaseDate.month == day.month &&
                  post.releaseDate.day == day.day)
              .toList();
        },
        onDaySelected: (tappedDay, focused) {
          selectedDay.value = tappedDay;
          focusedDay.value = focused;

          final myUid = ref.watch(authStateProvider).value?.uid;
          if (userPosts.any(
            (post) => isSameDay(post.releaseDate, tappedDay),
          )) {
            context.push('/user_diary_detail', extra: {
              'selectedPost': userPosts.firstWhere(
                (post) => isSameDay(post.releaseDate, tappedDay),
              ),
            });
          } else if (myUid == uid &&
              userPosts.any(
                (post) => !isSameDay(post.releaseDate, tappedDay),
              )) {
            context.go('/post', extra: {'selectedDay': selectedDay.value});
          } else if (myUid == uid && userPosts.isEmpty) {
            context.go('/post', extra: {'selectedDay': selectedDay.value});
          }
        },
        onPageChanged: (firstDayInMonth) async {
          // userPostsが空の場合は、focusedDayの更新のみ
          if (userPosts.isEmpty) {
            focusedDay.value = firstDayInMonth;
            return;
          }

          // 一番古い投稿を取得
          final oldestPost = userPosts.reduce(
            (a, b) => a.releaseDate.isBefore(b.releaseDate) ? a : b,
          );

          // 年月単位で比較するためのDateTimeオブジェクトを作成
          final displayedYearMonth =
              DateTime(firstDayInMonth.year, firstDayInMonth.month);
          final oldestYearMonth = DateTime(
              oldestPost.releaseDate.year, oldestPost.releaseDate.month);

          // 表示する年月が一番古い投稿の年月と一致する場合、追加読み込みを行う
          if (displayedYearMonth.isAtSameMomentAs(oldestYearMonth)) {
            final result =
                await ref.read(userPostLoadMoreUsecaseProvider).execute(
                      uid,
                      ref.read(userPostScrollStateNotifierProvider(uid)),
                      ref.read(userPostNotifierProvider(uid).notifier),
                    );

            if (result is Failure && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('データの読み込みに失敗しました。再度お試しください。')),
              );
            }

            focusedDay.value = firstDayInMonth;
          }
        },
        selectedDayPredicate: (day) {
          return isSameDay(selectedDay.value, day);
        },
        calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(color: Colors.white),
          selectedDecoration: BoxDecoration(
            color: Colors.lightGreen,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(color: Colors.white),
          outsideTextStyle: TextStyle(color: Colors.grey),
        ),
        daysOfWeekHeight: 26.r,
      ),
    );
  }
}
