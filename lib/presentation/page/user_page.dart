import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/domain/util/date_util.dart';
import 'package:green_heart/presentation/widget/post_card.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/domain/type/post_data.dart';

class UserPage extends ConsumerWidget {
  const UserPage({super.key, required this.profile, required this.postData});

  final List<PostData> postData;
  final Profile? profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    _buildUserImage(context, ref, profile?.imageUrl ?? ''),
                    Expanded(child: _buildUserStats()),
                  ],
                ),
                SizedBox(height: 16.r),
                _buildUserName(context, ref),
                SizedBox(height: 8.r),
                _buildBirthDate(context, ref),
                SizedBox(height: 16.r),
                _buildUserBio(context, ref),
                SizedBox(height: 16.r),
                _buildFollowButton(context, ref),
              ],
            ),
          ),
          SizedBox(height: 8.r),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildUserPosts(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildUserImage(
      BuildContext context, WidgetRef ref, String? imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: imageUrl == '' || imageUrl == null
              ? _buildEmptyImage()
              : _buildFirebaseImage(imageUrl),
        ),
      ],
    );
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

  Widget _buildFirebaseImage(String imageUrl) {
    return Container(
      width: 120.r,
      height: 120.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(imageUrl),
        ),
      ),
      child: CachedNetworkImage(
        key: ValueKey(imageUrl),
        imageUrl: imageUrl,
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

  Widget _buildUserName(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileNotifierProvider).value;
    return Text(
      profile?.name ?? '',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
      ),
    );
  }

  Widget _buildBirthDate(BuildContext context, WidgetRef ref) {
    return profile?.birthday == null
        ? const SizedBox()
        : Text('${DateUtil.convertToJapaneseDate(profile?.birthday!)}生まれ');
  }

  Widget _buildUserBio(BuildContext context, WidgetRef ref) {
    final bio = profile?.bio;
    return bio == null || bio.isEmpty ? const SizedBox() : Text(bio);
  }

  Widget _buildFollowButton(BuildContext context, WidgetRef ref) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {},
          child: const Text('フォローする'),
        ),
      ),
    );
  }

  Widget _buildUserPosts(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: postData.length,
      itemBuilder: (context, index) {
        return PostCard(postData: postData[index]);
      },
    );
  }
}
