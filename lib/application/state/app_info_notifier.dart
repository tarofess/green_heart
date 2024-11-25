import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/app_info.dart';
import 'package:green_heart/application/di/settings_di.dart';

class AppInfoNotifier extends AsyncNotifier<AppInfo> {
  @override
  Future<AppInfo> build() async {
    const developerName = 'ところやまたろう';
    const appVersion = '1.0.0';
    final termsOfUse = await ref
            .read(appInfoReadTextFileUsecaseProvider)
            .execute('terms_of_use.txt') ??
        '利用規約を取得できませんでした。';
    final privacyPolicy = await ref
            .read(appInfoReadTextFileUsecaseProvider)
            .execute('privacy_policy.txt') ??
        'プライバシーポリシーを取得できませんでした。';

    return AppInfo(
      developerName: developerName,
      appVersion: appVersion,
      termsOfUse: termsOfUse,
      privacyPolicy: privacyPolicy,
    );
  }
}

final appInfoNotifierProvider = AsyncNotifierProvider<AppInfoNotifier, AppInfo>(
  () => AppInfoNotifier(),
);
