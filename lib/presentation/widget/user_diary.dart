import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:green_heart/application/state/user_post_notifier.dart';
import 'package:green_heart/domain/type/post_data.dart';
import 'package:green_heart/presentation/widget/async_error_widget.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';

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
        return _buildCalendar(context, ref, userPosts, selectedDay, focusedDay);
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

  Widget _buildCalendar(
    BuildContext context,
    WidgetRef ref,
    List<PostData> userPosts,
    ValueNotifier<DateTime> selectedDay,
    ValueNotifier<DateTime> focusedDay,
  ) {
    return SingleChildScrollView(
      child: TableCalendar(
        availableGestures: AvailableGestures.none,
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2124, 12, 31),
        focusedDay: focusedDay.value,
        headerStyle: const HeaderStyle(formatButtonVisible: false),
        locale: 'ja_JP',
        rowHeight: 52.h,
        eventLoader: (day) {
          return userPosts
              .where((postData) =>
                  postData.post.releaseDate.year == day.year &&
                  postData.post.releaseDate.month == day.month &&
                  postData.post.releaseDate.day == day.day)
              .toList();
        },
        onDaySelected: (tappedDay, focused) {
          selectedDay.value = tappedDay;
          focusedDay.value = focused;

          if (userPosts.any((postData) =>
              isSameDay(postData.post.releaseDate, tappedDay) &&
              ref.watch(authStateProvider).value?.uid == uid)) {
            context.push('/user_diary_detail', extra: {
              'selectedPostData': userPosts.firstWhere(
                (postData) => isSameDay(postData.post.releaseDate, tappedDay),
              ),
            });
          } else {
            context.go('/post', extra: {'selectedDay': selectedDay.value});
          }
        },
        onPageChanged: (focusedDay) {},
        selectedDayPredicate: (day) {
          return isSameDay(selectedDay.value, day);
        },
        calendarStyle: CalendarStyle(
          todayDecoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(fontSize: 16.sp, color: Colors.white),
          selectedDecoration: const BoxDecoration(
            color: Colors.lightGreen,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(fontSize: 16.sp, color: Colors.white),
          defaultTextStyle: TextStyle(fontSize: 16.sp),
          weekendTextStyle: TextStyle(fontSize: 16.sp),
          outsideTextStyle: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(fontSize: 16.sp),
          weekendStyle: TextStyle(fontSize: 16.sp),
        ),
        daysOfWeekHeight: 26.r,
      ),
    );
  }
}
