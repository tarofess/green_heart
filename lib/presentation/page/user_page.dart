import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/domain/util/date_util.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/presentation/widget/user_post_list.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/application/state/block_notifier.dart';
import 'package:green_heart/presentation/dialog/confirmation_dialog.dart';
import 'package:green_heart/presentation/dialog/error_dialog.dart';
import 'package:green_heart/application/di/block_di.dart';
import 'package:green_heart/presentation/widget/post_search.dart';
import 'package:green_heart/application/state/user_post_scroll_state_notifier.dart';
import 'package:green_heart/application/di/report_di.dart';
import 'package:green_heart/presentation/dialog/report_dialog.dart';
import 'package:green_heart/presentation/widget/loading_overlay.dart';
import 'package:green_heart/presentation/widget/user_empty_image.dart';
import 'package:green_heart/presentation/widget/user_firebase_image.dart';
import 'package:green_heart/application/di/follow_di.dart';
import 'package:green_heart/application/state/follower_notifier.dart';
import 'package:green_heart/presentation/widget/follow_state_widget.dart';

class UserPage extends HookConsumerWidget {
  const UserPage({super.key, required this.uid});

  final String? uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = useState<Profile?>(null);
    final isFollowing = useState(false);
    final isBlocked = useState(false);
    final scrollController = useScrollController();

    useEffect(() {
      void setProfile() async {
        if (uid == null) return;
        profile.value = await ref.read(profileGetUsecaseProvider).execute(uid!);
      }

      void setFollowState() async {
        if (uid == null) return;
        final currentUid = ref.watch(authStateProvider).value?.uid;

        isFollowing.value = await ref.read(followCheckUsecaseProvider).execute(
              currentUid,
              uid!,
            );
      }

      void setBlockState() async {
        if (uid == null) return;
        final currentUid = ref.watch(authStateProvider).value?.uid;

        isBlocked.value = await ref.read(blockCheckUsecaseProvider).execute(
              currentUid,
              uid!,
            );
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(userPostScrollStateNotifierProvider(uid).notifier).reset();
      });

      try {
        setProfile();
        setFollowState();
        setBlockState();
      } catch (e) {
        if (context.mounted) {
          showErrorDialog(
            context: context,
            title: 'エラー発生',
            content: e.toString(),
          );
        }
      }

      return null;
    }, [ref.watch(profileNotifierProvider).value]);

    return Scaffold(
      appBar: uid == ref.watch(authStateProvider).value?.uid
          ? null
          : _buildAppBar(context, ref, profile, isFollowing, isBlocked),
      body: SafeArea(
        child: isBlocked.value
            ? _buildBlockedBody(context, ref, profile)
            : _buildBody(
                context,
                ref,
                profile,
                isFollowing,
                scrollController,
              ),
      ),
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<Profile?> profile,
    ValueNotifier<bool> isFollowing,
    ValueNotifier<bool> isBlocked,
  ) {
    return AppBar(
      centerTitle: true,
      title: Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: Image.asset(
          'assets/images/leaf.png',
          width: 100.w,
        ),
      ),
      toolbarHeight: 58.h,
      actions: [
        isBlocked.value
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
        isBlocked.value
            ? _buildBlockIconButton(context, ref, profile, isBlocked)
            : _buildPopupMenu(context, ref, profile, isFollowing, isBlocked),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<Profile?> profile,
    ValueNotifier<bool> isFollowing,
    ScrollController scrollController,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(userPostNotifierProvider(uid).notifier).refresh(uid);
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
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
                          _buildUserImage(context, ref, profile),
                          Expanded(
                            child: FollowStateWidget(uid: uid),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      _buildUserName(context, ref, profile.value),
                      SizedBox(height: 16.h),
                      _buildUserBio(context, ref, profile.value),
                      SizedBox(height: 24.h),
                      _buildBirthDate(context, ref, profile.value),
                      SizedBox(height: 16.h),
                      _buildFollowButton(context, ref, isFollowing),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                const Divider(),
              ],
            ),
          ),
          UserPostList(
            uid: uid,
            scrollController: scrollController,
          ),
        ],
      ),
    );
  }

  Widget _buildUserImage(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<Profile?> profile,
  ) {
    return profile.value?.imageUrl == null
        ? const UserEmptyImage(radius: 60)
        : UserFirebaseImage(imageUrl: profile.value?.imageUrl, radius: 120);
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
    ValueNotifier<bool> isFollowing,
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
                      if (isFollowing.value) {
                        await ref
                            .read(followerNotifierProvider(uid).notifier)
                            .unfollow(myUid!, uid!);

                        isFollowing.value = false;
                      } else {
                        await ref
                            .read(followerNotifierProvider(uid).notifier)
                            .follow(myUid!, uid!);

                        isFollowing.value = true;
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
                style: isFollowing.value
                    ? ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      )
                    : null,
                child: Text(
                  isFollowing.value ? 'フォロー中' : 'フォローする',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: isFollowing.value ? Colors.white : null,
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildBlockedBody(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<Profile?> profile,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: 32.w, right: 32.w, bottom: 52.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildUserImage(context, ref, profile),
            SizedBox(height: 32.h),
            Text(
              'あなたは${profile.value?.name}をブロックしています。',
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
    ValueNotifier<Profile?> profile,
    ValueNotifier<bool> isBlocked,
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
                  '${profile.value?.name}のブロックを解除しました。',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
            );
          }

          isBlocked.value = false;
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
    ValueNotifier<Profile?> profile,
    ValueNotifier<bool> isFollowing,
    ValueNotifier<bool> isBlocked,
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
                  isFollowing.value = false;
                });
              }

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${profile.value?.name}をブロックしました。',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                );
              }

              isBlocked.value = true;
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
