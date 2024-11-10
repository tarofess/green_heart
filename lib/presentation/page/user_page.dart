import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/domain/util/date_util.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/block_notifier.dart';
import 'package:green_heart/presentation/dialog/confirmation_dialog.dart';
import 'package:green_heart/presentation/dialog/error_dialog.dart';
import 'package:green_heart/presentation/widget/post_search.dart';
import 'package:green_heart/application/di/report_di.dart';
import 'package:green_heart/presentation/dialog/report_dialog.dart';
import 'package:green_heart/presentation/widget/loading_overlay.dart';
import 'package:green_heart/presentation/widget/user_empty_image.dart';
import 'package:green_heart/presentation/widget/user_firebase_image.dart';
import 'package:green_heart/application/state/follower_notifier.dart';
import 'package:green_heart/presentation/widget/follow_state_widget.dart';
import 'package:green_heart/presentation/widget/user_page_tab.dart';
import 'package:green_heart/application/state/user_page_state_notifier.dart';
import 'package:green_heart/presentation/widget/async_error_widget.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/domain/type/user_page_state.dart';

class UserPage extends HookConsumerWidget {
  const UserPage({super.key, required this.uid});

  final String? uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPageStateProvider = ref.watch(userPageStateNotifierProvider(uid));
    final scrollController = useScrollController();

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
                    scrollController,
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
      toolbarHeight: 58.h,
      actions: [
        userPageState.isBlocked
            ? const SizedBox()
            : IconButton(
                icon: Icon(Icons.search, size: 24.r),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: PostSearch(
                      postSearchType: PostSearchType.user,
                      uid: uid,
                    ),
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
    ScrollController scrollController,
  ) {
    return DefaultTabController(
      length: 2,
      child: RefreshIndicator(
        onRefresh: () async {
          await ref.read(userPostNotifierProvider(uid).notifier).refresh(uid);
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16.w, right: 16.w),
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
                            Expanded(
                              child: FollowStateWidget(uid: uid),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        _buildUserName(context, ref, userPageState.profile),
                        SizedBox(height: 16.h),
                        _buildUserBio(context, ref, userPageState.profile),
                        userPageState.profile?.birthday == null
                            ? const SizedBox()
                            : SizedBox(height: 24.h),
                        _buildBirthDate(context, ref, userPageState.profile),
                        uid == ref.watch(authStateProvider).value?.uid
                            ? const SizedBox()
                            : SizedBox(height: 24.h),
                        _buildFollowButton(context, ref, userPageState),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 8.h)),
            SliverFillRemaining(
              child: UserPageTab(
                uid: uid,
                scrollController: scrollController,
              ),
            ),
          ],
        ),
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
    return Text(
      profile?.name ?? '',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18.sp,
      ),
    );
  }

  Widget _buildBirthDate(
      BuildContext context, WidgetRef ref, Profile? profile) {
    return profile?.birthday == null
        ? const SizedBox()
        : Text(
            '誕生日: ${DateUtil.convertToJapaneseDate(profile?.birthday!)}',
            style: TextStyle(fontSize: 13.sp),
          );
  }

  Widget _buildUserBio(BuildContext context, WidgetRef ref, Profile? profile) {
    final bio = profile?.bio;
    return bio == null || bio.isEmpty
        ? const SizedBox()
        : Text(
            bio,
            style: TextStyle(fontSize: 16.sp),
          );
  }

  Widget _buildFollowButton(
    BuildContext context,
    WidgetRef ref,
    UserPageState userPageState,
  ) {
    return uid == ref.watch(authStateProvider).value?.uid
        ? const SizedBox()
        : Center(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await LoadingOverlay.of(
                      context,
                      backgroundColor: Colors.white10,
                    ).during(() async {
                      final myUid = ref.watch(authStateProvider).value?.uid;
                      if (userPageState.isFollowing) {
                        await ref
                            .read(followerNotifierProvider(uid).notifier)
                            .unfollow(myUid!, uid!);
                        ref
                            .read(userPageStateNotifierProvider(uid).notifier)
                            .setIsFollowing(false);
                      } else {
                        await ref
                            .read(followerNotifierProvider(uid).notifier)
                            .follow(myUid!, uid!);
                        ref
                            .read(userPageStateNotifierProvider(uid).notifier)
                            .setIsFollowing(true);
                      }
                    });
                  } catch (e) {
                    if (context.mounted) {
                      showErrorDialog(
                        context: context,
                        title: 'フォローエラー',
                        content: e.toString(),
                      );
                    }
                  }
                },
                style: userPageState.isFollowing
                    ? ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      )
                    : null,
                child: Text(
                  userPageState.isFollowing ? 'フォロー中' : 'フォローする',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: userPageState.isFollowing ? Colors.white : null,
                  ),
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
            Text(
              'あなたは${userPageState.profile?.name}をブロックしています。',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
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
        try {
          final result = await showConfirmationDialog(
            context: context,
            title: 'ブロック解除',
            content: 'このユーザーのブロックを解除しますか？',
            positiveButtonText: 'ブロック解除',
            negativeButtonText: 'キャンセル',
          );
          if (!result) return;

          if (context.mounted) {
            await LoadingOverlay.of(
              context,
              message: 'ブロック解除中',
              backgroundColor: Colors.white10,
            ).during(
              () => ref.read(blockNotifierProvider.notifier).deleteBlock(uid!),
            );
          }

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${userPageState.profile?.name}のブロックを解除しました。',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
            );
          }

          ref
              .read(userPageStateNotifierProvider(uid).notifier)
              .setIsBlocked(false);
        } catch (e) {
          if (context.mounted) {
            showErrorDialog(
              context: context,
              title: 'ブロック解除エラー',
              content: e.toString(),
            );
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
            try {
              final reportText = await showReportDialog(context);
              if (reportText == null) return;

              final reporterIid = ref.watch(authStateProvider).value?.uid;
              if (reporterIid == null) return;

              if (context.mounted) {
                await LoadingOverlay.of(
                  context,
                  message: '通報中',
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
              }

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'ユーザーを通報しました。',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                );
              }
            } catch (e) {
              if (context.mounted) {
                showErrorDialog(
                  context: context,
                  title: '通報エラー',
                  content: e.toString(),
                );
              }
            }
            break;
          case 'block':
            try {
              if (ref.watch(authStateProvider).value == null && uid == null) {
                return;
              }

              final result = await showConfirmationDialog(
                context: context,
                title: 'ブロック',
                content: 'このユーザーをブロックしますか？',
                positiveButtonText: 'ブロックする',
                negativeButtonText: 'キャンセル',
              );
              if (!result) return;

              if (context.mounted) {
                await LoadingOverlay.of(
                  context,
                  message: 'ブロック中',
                  backgroundColor: Colors.white10,
                ).during(() async {
                  final myUid = ref.watch(authStateProvider).value?.uid;
                  await ref.read(blockNotifierProvider.notifier).addBlock(uid!);
                  await ref
                      .read(followerNotifierProvider(uid).notifier)
                      .unfollow(myUid!, uid!);
                  await ref
                      .read(followerNotifierProvider(uid).notifier)
                      .unfollow(uid!, myUid);
                  ref
                      .read(userPageStateNotifierProvider(uid).notifier)
                      .setIsFollowing(false);
                });
              }

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${userPageState.profile?.name}をブロックしました。',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                );
              }

              ref
                  .read(userPageStateNotifierProvider(uid).notifier)
                  .setIsBlocked(true);
            } catch (e) {
              if (context.mounted) {
                showErrorDialog(
                  context: context,
                  title: 'ブロックエラー',
                  content: e.toString(),
                );
              }
            }
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'report',
          child: Text(
            '通報する',
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
        PopupMenuItem<String>(
          value: 'block',
          child: Text(
            'ブロックする',
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
      ],
    );
  }
}
