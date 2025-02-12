import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/device_info_di.dart';
import 'package:green_heart/application/di/notification_setting_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/domain/type/result.dart';
import 'package:green_heart/presentation/widget/loading_overlay.dart';

class NotificationSettingPage extends HookConsumerWidget {
  const NotificationSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likeSwitchValue = useState(false);
    final commentSwitchValue = useState(false);
    final followerSwitchValue = useState(false);
    final uid = ref.watch(authStateProvider).value?.uid;

    useEffect(() {
      void setSwitchValues() async {
        final deviceId = await ref.read(deviceInfoGetUsecaseProvider).execute();

        if (uid == null || deviceId == null) return;

        final notification = await ref
            .read(notificationSettingGetUsecaseProvider)
            .execute(uid, deviceId);

        if (notification == null) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('通知設定の取得に失敗したため、全てオフで表示しています。')),
            );
          }

          return;
        }

        likeSwitchValue.value = notification.likeSetting;
        commentSwitchValue.value = notification.commentSetting;
        followerSwitchValue.value = notification.followerSetting;
      }

      setSwitchValues();

      return;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('通知設定'),
        actions: [
          TextButton(
            child: const Text(
              '保存',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
            onPressed: () async {
              final uid = ref.watch(authStateProvider).value?.uid;
              final deviceId =
                  await ref.read(deviceInfoGetUsecaseProvider).execute();

              if (!context.mounted) return;

              if (uid == null || deviceId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('予期せぬエラーが発生しました。再度お試しください。')),
                );

                return;
              }

              final result = await LoadingOverlay.of(
                context,
                message: '設定中',
                backgroundColor: Colors.white10,
              ).during(
                () => ref.read(notificationSettingUpdateUsecaeProvider).execute(
                      uid,
                      deviceId,
                      likeSwitchValue.value,
                      commentSwitchValue.value,
                      followerSwitchValue.value,
                    ),
              );

              if (!context.mounted) return;

              switch (result) {
                case Success():
                  Navigator.of(context).pop();
                  break;
                case Failure(message: final message):
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('エラーが発生し、通知設定が更新できませんでした: $message')),
                  );
                  Navigator.of(context).pop();
                  break;
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 4.h, left: 4.w),
        child: Center(
          child: ListView(
            children: [
              _buildLikeSwitch(context, ref, likeSwitchValue),
              _buildCommentSwitch(context, ref, commentSwitchValue),
              _buildFollowerSwitch(context, ref, followerSwitchValue),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLikeSwitch(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> likeSwitchValue,
  ) {
    return ListTile(
      title: const Text('いいね'),
      trailing: Switch(
        value: likeSwitchValue.value,
        activeColor: Colors.green[500],
        activeTrackColor: Colors.green[100],
        onChanged: (value) {
          likeSwitchValue.value = value;
        },
      ),
    );
  }

  Widget _buildCommentSwitch(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> replySwitchValue,
  ) {
    return ListTile(
      title: const Text('コメント'),
      trailing: Switch(
        value: replySwitchValue.value,
        activeColor: Colors.green[500],
        activeTrackColor: Colors.green[100],
        onChanged: (value) {
          replySwitchValue.value = value;
        },
      ),
    );
  }

  Widget _buildFollowerSwitch(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> newFollowerSwitchValue,
  ) {
    return ListTile(
      title: const Text('新しいフォロワー'),
      trailing: Switch(
        value: newFollowerSwitchValue.value,
        activeColor: Colors.green[500],
        activeTrackColor: Colors.green[100],
        onChanged: (value) {
          newFollowerSwitchValue.value = value;
        },
      ),
    );
  }
}
