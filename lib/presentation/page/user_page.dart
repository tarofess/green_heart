import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/presentation/dialog/report_dialog.dart';
import 'package:green_heart/presentation/widget/loading_overlay.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/domain/util/date_util.dart';
import 'package:green_heart/presentation/widget/post_card.dart';
import 'package:green_heart/domain/type/post_data.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/presentation/page/error_page.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/application/state/block_notifier.dart';
import 'package:green_heart/presentation/dialog/confirmation_dialog.dart';
import 'package:green_heart/presentation/dialog/error_dialog.dart';
import 'package:green_heart/application/di/block_di.dart';
import 'package:green_heart/presentation/widget/post_search.dart';
import 'package:green_heart/application/state/user_post_scroll_state_notifier.dart';

class UserPage extends StatefulHookConsumerWidget {
  const UserPage({super.key, required this.uid});
  final String? uid;

  @override
  ConsumerState<UserPage> createState() => _UserPageState();
}

class _UserPageState extends ConsumerState<UserPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
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

    await ref.read(userPostNotifierProvider(widget.uid).notifier).loadMore();

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final userPostState = ref.watch(userPostNotifierProvider(widget.uid));
    final profile = useState<Profile?>(null);
    final isBlocked = useState(false);

    useEffect(() {
      void setProfile() async {
        if (widget.uid == null) return;
        profile.value =
            await ref.read(profileGetUsecaseProvider).execute(widget.uid!);
      }

      void setBlockState() async {
        if (widget.uid == null) return;

        isBlocked.value = await ref
            .read(blockCheckUsecaseProvider)
            .execute(ref.watch(authStateProvider).value?.uid, widget.uid!);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(userPostScrollStateNotifierProvider.notifier).reset();
      });

      setProfile();
      setBlockState();
      return;
    }, [ref.watch(profileNotifierProvider).value]);

    return Scaffold(
      appBar: widget.uid == ref.watch(authStateProvider).value?.uid
          ? null
          : _buildAppBar(context, ref, userPostState, profile, isBlocked),
      body: userPostState.when(
        data: (userPosts) {
          return isBlocked.value
              ? _buildBlockedBody(context, ref, profile)
              : _buildBody(context, ref, profile, userPosts);
        },
        loading: () => const LoadingIndicator(),
        error: (e, _) => ErrorPage(
          error: e,
          retry: () => ref.refresh(userPostNotifierProvider(widget.uid)),
        ),
      ),
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<PostData>> userPostState,
    ValueNotifier<Profile?> profile,
    ValueNotifier<bool> isBlocked,
  ) {
    return AppBar(
      title: const Text(''),
      actions: [
        isBlocked.value
            ? const SizedBox()
            : IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: PostSearch(),
                  );
                },
              ),
        isBlocked.value
            ? IconButton(
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

                    await ref
                        .read(blockNotifierProvider.notifier)
                        .deleteBlock(widget.uid!);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${profile.value?.name}のブロックを解除しました。'),
                        ),
                      );
                    }

                    isBlocked.value = false;
                  } catch (e) {
                    if (context.mounted) {
                      showErrorDialog(
                        context: context,
                        title: 'ブロックエラー',
                        content: e.toString(),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.block))
            : PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz),
                onSelected: (String result) async {
                  switch (result) {
                    case 'report':
                      try {
                        final reportText = await showReportDialog(context);
                        if (reportText == null) return;

                        final reporterIid =
                            ref.watch(authStateProvider).value?.uid;
                        if (reporterIid == null) return;

                        if (context.mounted) {
                          await LoadingOverlay.of(context).during(
                            () => ref.read(reportAddUsecaseProvider).execute(
                                  reporterIid,
                                  reportText,
                                  reportedPostId: null,
                                  reportedCommentId: null,
                                  reportedUserId: widget.uid,
                                ),
                          );
                        }

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('ユーザーを通報しました。'),
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
                        if (ref.watch(authStateProvider).value == null &&
                            widget.uid == null) {
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

                        await ref
                            .read(blockNotifierProvider.notifier)
                            .addBlock(widget.uid!);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${profile.value?.name}をブロックしました。'),
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
                  const PopupMenuItem<String>(
                    value: 'report',
                    child: Text('通報する'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'block',
                    child: Text('ブロックする'),
                  ),
                ],
              )
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<Profile?> profile,
    List<PostData> userPosts,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(userPostNotifierProvider(widget.uid).notifier).refresh();
      },
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.r, right: 16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildUserImage(context, ref, profile),
                          Expanded(child: _buildUserStats()),
                        ],
                      ),
                      SizedBox(height: 16.r),
                      _buildUserName(context, ref, profile.value),
                      SizedBox(height: 8.r),
                      _buildBirthDate(context, ref, profile.value),
                      SizedBox(height: 16.r),
                      _buildUserBio(context, ref, profile.value),
                      SizedBox(height: 16.r),
                      _buildFollowButton(context, ref),
                    ],
                  ),
                ),
                SizedBox(height: 8.r),
                const Divider(),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: _buildUserPosts(context, ref, userPosts),
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
        ? _buildEmptyImage()
        : _buildFirebaseImage(profile);
  }

  Widget _buildEmptyImage() {
    return CircleAvatar(
      radius: 60.r,
      backgroundColor: Colors.grey[200],
      child: Icon(
        Icons.person,
        size: 60.r,
        color: Colors.grey[500],
      ),
    );
  }

  Widget _buildFirebaseImage(ValueNotifier<Profile?> profile) {
    return Container(
      width: 120.r,
      height: 120.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(profile.value?.imageUrl ?? ''),
        ),
      ),
      child: CachedNetworkImage(
        imageUrl: profile.value?.imageUrl ?? '',
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  Widget _buildUserStats() {
    return SizedBox(
      height: 120.r,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {},
                child: Column(
                  children: [
                    const Text('フォロワー'),
                    Text(
                      '120',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Column(
                  children: [
                    const Text('フォロー中'),
                    Text(
                      '63',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserName(BuildContext context, WidgetRef ref, Profile? profile) {
    return Text(
      profile?.name ?? '',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
      ),
    );
  }

  Widget _buildBirthDate(
      BuildContext context, WidgetRef ref, Profile? profile) {
    return profile?.birthday == null
        ? const SizedBox()
        : Text('${DateUtil.convertToJapaneseDate(profile?.birthday!)}生まれ');
  }

  Widget _buildUserBio(BuildContext context, WidgetRef ref, Profile? profile) {
    final bio = profile?.bio;
    return bio == null || bio.isEmpty ? const SizedBox() : Text(bio);
  }

  Widget _buildFollowButton(BuildContext context, WidgetRef ref) {
    return widget.uid == ref.watch(authStateProvider).value?.uid
        ? const SizedBox()
        : Center(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {},
                child: const Text('フォローする'),
              ),
            ),
          );
  }

  Widget _buildUserPosts(
    BuildContext context,
    WidgetRef ref,
    List<PostData> userPosts,
  ) {
    return userPosts.isEmpty
        ? const SliverToBoxAdapter(child: Center(child: Text('投稿はまだありません。')))
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == userPosts.length) {
                  return _isLoadingMore
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox.shrink();
                }
                return PostCard(
                  key: ValueKey(userPosts[index]),
                  postData: userPosts[index],
                  uidInPreviosPage: widget.uid,
                );
              },
              childCount: userPosts.length + 1,
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
        padding: const EdgeInsets.only(left: 32, right: 32, bottom: 52),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildUserImage(context, ref, profile),
            const SizedBox(height: 32),
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
}
