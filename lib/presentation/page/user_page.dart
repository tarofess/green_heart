import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/domain/util/date_util.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/presentation/dialog/confirmation_dialog.dart';
import 'package:green_heart/presentation/dialog/error_dialog.dart';
import 'package:green_heart/presentation/widget/post_search.dart';
import 'package:green_heart/application/di/report_di.dart';
import 'package:green_heart/presentation/dialog/report_dialog.dart';
import 'package:green_heart/presentation/widget/loading_overlay.dart';
import 'package:green_heart/presentation/widget/user_empty_image.dart';
import 'package:green_heart/presentation/widget/user_firebase_image.dart';
import 'package:green_heart/presentation/widget/follow_state_widget.dart';
import 'package:green_heart/presentation/widget/user_page_tab.dart';
import 'package:green_heart/application/state/user_page_state_notifier.dart';
import 'package:green_heart/presentation/widget/async_error_widget.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/domain/type/user_page_state.dart';
import 'package:green_heart/application/state/follow_notifier.dart';
import 'package:green_heart/application/di/block_di.dart';
import 'package:green_heart/application/di/follow_di.dart';
import 'package:green_heart/domain/type/result.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/application/state/follower_notifier.dart';

class UserPage extends HookConsumerWidget {
  const UserPage({super.key, required this.uid});

  final String? uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPageStateProvider = ref.watch(userPageStateNotifierProvider(uid));
    final customScrollViewScrollController = useScrollController();
    final userPageTabScrollController = useScrollController();

    return userPageStateProvider.when(
      data: (userPageState) {
        return Scaffold(
          appBar: uid == ref.watch(authStateProvider).value?.uid
              ? null
              : _buildAppBar(context, ref, userPageState),
          body: SafeArea(
            child: userPageState.isBlocked
                ? _buildBlockedBody(context, ref, userPageState)
                : _buildBody(
                    context,
                    ref,
                    userPageState,
                    customScrollViewScrollController,
                    userPageTabScrollController,
                  ),
          ),
        );
      },
      loading: () {
        return const Scaffold(
          body: LoadingIndicator(message: '読み込み中'),
        );
      },
      error: (e, _) {
        return Scaffold(
          body: AsyncErrorWidget(
            error: e,
            retry: () => ref.refresh(userPageStateNotifierProvider(uid)),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    UserPageState userPageState,
  ) {
    return AppBar(
      title: Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: Image.asset(
          'assets/images/leaf.png',
          width: 100.w,
        ),
      ),
      actions: [
        userPageState.isBlocked
            ? const SizedBox.shrink()
            : IconButton(
                icon: Icon(Icons.search, size: 24.r),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: PostSearch(uid: uid),
                  );
                },
              ),
        userPageState.isBlocked
            ? _buildBlockIconButton(context, ref, userPageState)
            : _buildPopupMenu(context, ref, userPageState),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    UserPageState userPageState,
    ScrollController customScrollViewScrollController,
    ScrollController userPageTabScrollController,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        // ignore: unused_result
        ref.refresh(userPageStateNotifierProvider(uid));
        // ignore: unused_result
        ref.refresh(followNotifierProvider(uid));
        // ignore: unused_result
        ref.refresh(followerNotifierProvider(uid));
      },
      child: CustomScrollView(
        controller: customScrollViewScrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildUserImage(
                            context,
                            ref,
                            userPageState.profile,
                          ),
                          Expanded(child: FollowStateWidget(uid: uid)),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      _buildUserName(context, ref, userPageState.profile),
                      userPageState.profile?.bio == null ||
                              userPageState.profile?.bio.isEmpty == true
                          ? const SizedBox.shrink()
                          : SizedBox(height: 16.h),
                      _buildUserBio(context, ref, userPageState.profile),
                      userPageState.profile?.birthday == null
                          ? const SizedBox.shrink()
                          : SizedBox(height: 24.h),
                      _buildBirthDate(context, ref, userPageState.profile),
                      uid == ref.watch(authStateProvider).value?.uid ||
                              userPageState.profile?.name == null
                          ? const SizedBox.shrink()
                          : SizedBox(height: 24.h),
                      _buildFollowButton(context, ref, userPageState),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          SliverFillRemaining(
            child: UserPageTab(
              uid: uid,
              scrollController: userPageTabScrollController,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserImage(
    BuildContext context,
    WidgetRef ref,
    Profile? profile,
  ) {
    return profile?.imageUrl == null
        ? const UserEmptyImage(radius: 60)
        : UserFirebaseImage(imageUrl: profile?.imageUrl, radius: 120);
  }

  Widget _buildUserName(BuildContext context, WidgetRef ref, Profile? profile) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Text(
        profile?.name ?? 'ユーザーは存在しません',
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBirthDate(
      BuildContext context, WidgetRef ref, Profile? profile) {
    return profile?.birthday == null
        ? const SizedBox.shrink()
        : Text(
            '誕生日: ${DateUtil.convertToJapaneseDate(profile?.birthday!)}',
            style: Theme.of(context).textTheme.bodySmall,
          );
  }

  Widget _buildUserBio(BuildContext context, WidgetRef ref, Profile? profile) {
    final bio = profile?.bio;
    return bio == null || bio.isEmpty ? const SizedBox.shrink() : Text(bio);
  }

  Widget _buildFollowButton(
    BuildContext context,
    WidgetRef ref,
    UserPageState userPageState,
  ) {
    return uid == ref.watch(authStateProvider).value?.uid ||
            userPageState.profile?.name == null
        ? const SizedBox.shrink()
        : Center(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await LoadingOverlay.of(
                    context,
                    backgroundColor: Colors.white10,
                  ).during(() async {
                    final myUid = ref.watch(authStateProvider).value?.uid;
                    final profile = ref.watch(profileNotifierProvider).value;
                    return ref.read(followUsecaseProvider).execute(
                          myUid,
                          uid,
                          userPageState,
                          profile,
                          ref.read(followNotifierProvider(myUid).notifier),
                          ref.read(
                            userPageStateNotifierProvider(uid).notifier,
                          ),
                        );
                  });

                  switch (result) {
                    case Success():
                      break;
                    case Failure(message: final message):
                      if (context.mounted) {
                        showErrorDialog(
                          context: context,
                          title: 'フォローエラー',
                          content: message,
                        );
                        break;
                      }
                  }
                },
                style: userPageState.isFollowing
                    ? ElevatedButton.styleFrom(backgroundColor: Colors.green)
                    : null,
                child: Text(
                  userPageState.isFollowing ? 'フォロー中' : 'フォローする',
                  style: TextStyle(
                      color: userPageState.isFollowing ? Colors.white : null),
                ),
              ),
            ),
          );
  }

  Widget _buildBlockedBody(
    BuildContext context,
    WidgetRef ref,
    UserPageState userPageState,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: 32.w, right: 32.w, bottom: 52.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildUserImage(context, ref, userPageState.profile),
            SizedBox(height: 32.h),
            Text('あなたは${userPageState.profile?.name}をブロックしています'),
          ],
        ),
      ),
    );
  }

  Widget _buildBlockIconButton(
    BuildContext context,
    WidgetRef ref,
    UserPageState userPageState,
  ) {
    return IconButton(
      icon: Icon(Icons.block, size: 24.sp),
      onPressed: () async {
        final isConfirmed = await showConfirmationDialog(
          context: context,
          title: 'ブロック解除',
          content: 'このユーザーのブロックを解除しますか？',
          positiveButtonText: 'ブロック解除',
          negativeButtonText: 'キャンセル',
        );
        if (!isConfirmed) return;

        if (context.mounted) {
          final result = await LoadingOverlay.of(
            context,
            backgroundColor: Colors.white10,
          ).during(
            () {
              final myUid = ref.watch(authStateProvider).value?.uid;
              return ref.read(blockDeleteUsecaseProvider).execute(myUid, uid);
            },
          );

          switch (result) {
            case Success():
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${userPageState.profile?.name}のブロックを解除しました。',
                    ),
                  ),
                );
                ref
                    .read(userPageStateNotifierProvider(uid).notifier)
                    .setIsBlocked(false);
              }
              break;
            case Failure(message: final message):
              if (context.mounted) {
                showErrorDialog(
                  context: context,
                  title: 'ブロック解除エラー',
                  content: message,
                );
              }
              break;
          }
        }
      },
    );
  }

  Widget _buildPopupMenu(
    BuildContext context,
    WidgetRef ref,
    UserPageState userPageState,
  ) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_horiz, size: 24.r),
      onSelected: (String result) async {
        switch (result) {
          case 'report':
            final reportText = await showReportDialog(context);
            if (reportText == null) return;

            final reporterIid = ref.watch(authStateProvider).value?.uid;
            if (reporterIid == null) return;

            if (context.mounted) {
              final result = await LoadingOverlay.of(
                context,
                backgroundColor: Colors.white10,
              ).during(
                () => ref.read(reportAddUsecaseProvider).execute(
                      reporterIid,
                      reportText,
                      reportedPostId: null,
                      reportedCommentId: null,
                      reportedUserId: uid,
                    ),
              );

              switch (result) {
                case Success():
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ユーザーを通報しました。')),
                    );
                  }
                  break;
                case Failure(message: final message):
                  if (context.mounted) {
                    showErrorDialog(
                      context: context,
                      title: '通報エラー',
                      content: message,
                    );
                    break;
                  }
              }
            }
            break;
          case 'block':
            if (ref.watch(authStateProvider).value == null && uid == null) {
              return;
            }

            final isConfirmed = await showConfirmationDialog(
              context: context,
              title: 'ブロック',
              content: 'このユーザーをブロックしますか？',
              positiveButtonText: 'ブロックする',
              negativeButtonText: 'キャンセル',
            );
            if (!isConfirmed) return;

            if (context.mounted) {
              final result = await LoadingOverlay.of(
                context,
                backgroundColor: Colors.white10,
              ).during(() async {
                final myUid = ref.watch(authStateProvider).value?.uid;
                final blockResult =
                    await ref.read(blockAddUsecaseProvider).execute(
                          myUid,
                          uid,
                          userPageState.profile,
                        );
                if (blockResult is Failure) return blockResult;

                final unfollowResult =
                    await ref.read(unfollowUsecaseProvider).execute(
                          myUid,
                          uid,
                          userPageState,
                          ref.read(followNotifierProvider(myUid).notifier),
                          ref.read(followNotifierProvider(uid).notifier),
                          ref.read(userPageStateNotifierProvider(uid).notifier),
                        );
                return unfollowResult;
              });

              switch (result) {
                case Success():
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${userPageState.profile?.name}をブロックしました。',
                        ),
                      ),
                    );
                  }
                  ref
                      .read(userPageStateNotifierProvider(uid).notifier)
                      .setIsBlocked(true);
                  break;
                case Failure(message: final message):
                  if (context.mounted) {
                    showErrorDialog(
                      context: context,
                      title: 'ブロックエラー',
                      content: message,
                    );
                  }
                  break;
              }
            }
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'report',
          child: Text('通報する'),
        ),
        const PopupMenuItem<String>(
          value: 'block',
          child: Text('ブロックする'),
        ),
      ],
    );
  }
}
