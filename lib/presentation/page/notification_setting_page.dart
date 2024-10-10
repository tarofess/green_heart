import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationSettingPage extends HookConsumerWidget {
  const NotificationSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likeSwitchValue = useState(true);
    final replySwitchValue = useState(true);
    final newFollowerSwitchValue = useState(true);

    return Scaffold(
      appBar: AppBar(title: const Text('通知設定')),
      body: Center(
        child: ListView(
          children: [
            _buildLikeSwitch(context, ref, likeSwitchValue),
            _buildReplySwitch(context, ref, replySwitchValue),
            _buildNewFollowerSwitch(context, ref, newFollowerSwitchValue),
          ],
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
        activeColor: Colors.green[700],
        activeTrackColor: Colors.green[100],
        onChanged: (value) {
          likeSwitchValue.value = value;
        },
      ),
    );
  }

  Widget _buildReplySwitch(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> replySwitchValue,
  ) {
    return ListTile(
      title: const Text('返信'),
      trailing: Switch(
        value: replySwitchValue.value,
        activeColor: Colors.green[700],
        activeTrackColor: Colors.green[100],
        onChanged: (value) {
          replySwitchValue.value = value;
        },
      ),
    );
  }

  Widget _buildNewFollowerSwitch(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> newFollowerSwitchValue,
  ) {
    return ListTile(
      title: const Text('新しいフォロワー'),
      trailing: Switch(
        value: newFollowerSwitchValue.value,
        activeColor: Colors.green[700],
        activeTrackColor: Colors.green[100],
        onChanged: (value) {
          newFollowerSwitchValue.value = value;
        },
      ),
    );
  }
}
