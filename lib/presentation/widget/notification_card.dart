import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/notification.dart' as custom;
import 'package:green_heart/presentation/widget/user_empty_image.dart';
import 'package:green_heart/presentation/widget/user_firebase_image.dart';

class NotificationCard extends ConsumerWidget {
  const NotificationCard({super.key, required this.notification});

  final custom.Notification notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: notification.isRead == true ? Colors.grey[200] : Colors.white,
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNotificationActionType(context, ref),
            notification.type == 'follow'
                ? const SizedBox.shrink()
                : SizedBox(height: 16.h),
            _buildTextContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationActionType(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            context.push('/user', extra: {'uid': notification.senderUid});
          },
          child: notification.senderUserImage == null
              ? const UserEmptyImage(radius: 24)
              : UserFirebaseImage(
                  imageUrl: notification.senderUserImage,
                  radius: 48,
                ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: notification.senderUserName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: 'さんが'),
                  ],
                ),
              ),
              if (notification.type == 'like') const Text('あなたの投稿にいいねしました'),
              if (notification.type == 'comment') const Text('あなたの投稿にコメントしました'),
              if (notification.type == 'follow') const Text('あなたをフォローしました'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextContent() {
    return notification.postContent == null
        ? const SizedBox.shrink()
        : Text(
            notification.postContent!,
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          );
  }
}
