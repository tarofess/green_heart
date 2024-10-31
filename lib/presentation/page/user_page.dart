import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class UserPage extends HookConsumerWidget {
  const UserPage({super.key, required this.uid});

  final String? uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPostState = ref.watch(userPostNotifierProvider(uid));
    final profile = useState<Profile?>(null);

    useEffect(() {
      void setProfile() async {
        if (uid == null) return;

        uid == ref.watch(authStateProvider).value?.uid
            ? profile.value = ref.read(profileNotifierProvider).value
            : profile.value =
                await ref.read(profileGetUsecaseProvider).execute(uid!);
      }

      setProfile();
      return;
    }, [ref.watch(profileNotifierProvider).value]);

    return Scaffold(
      appBar: uid == ref.watch(authStateProvider).value?.uid
          ? null
          : AppBar(
              title: const Text(''),
            ),
      body: userPostState.when(
        data: (userPosts) {
          return SingleChildScrollView(
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildUserPosts(context, ref, userPosts),
                ),
              ],
            ),
          );
        },
        loading: () {
          return const LoadingIndicator();
        },
        error: (e, _) {
          return ErrorPage(
            error: e,
            retry: () => ref.refresh(userPostNotifierProvider(uid)),
          );
        },
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
    return uid == ref.watch(authStateProvider).value?.uid
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
        ? const Center(child: Text('投稿はまだありません。'))
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: userPosts.length,
            itemBuilder: (context, index) {
              return PostCard(
                key: ValueKey(userPosts[index]),
                postData: userPosts[index],
              );
            },
          );
  }
}
