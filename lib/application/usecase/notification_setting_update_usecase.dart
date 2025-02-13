import 'package:green_heart/application/interface/notification_setting_repository.dart';
import 'package:green_heart/domain/type/result.dart';

class NotificationSettingUpdateUsecase {
  final NotificationSettingRepository _notificationRepository;

  NotificationSettingUpdateUsecase(this._notificationRepository);

  Future<Result> execute(
    String uid,
    String deviceId,
    bool likeSetting,
    bool commentSetting,
    bool followerSetting,
  ) async {
    try {
      await _notificationRepository.updateEachNotificationStatus(
        uid,
        deviceId,
        likeSetting,
        commentSetting,
        followerSetting,
      );

      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
