import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:green_heart/application/interface/notification_repository.dart';
import 'package:green_heart/application/usecase/string_get_shared_pref_usecase.dart';
import 'package:green_heart/application/usecase/string_save_shared_pref_usecase.dart';

class FcmTokenSaveUsecase {
  final NotificationRepository _notificationRepository;
  final StringGetSharedPrefUsecase _getSharedPreferences;
  final StringSaveSharedPrefUsecase _saveSharedPreferences;

  FcmTokenSaveUsecase(
    this._notificationRepository,
    this._getSharedPreferences,
    this._saveSharedPreferences,
  );

  Future<void> execute(String uid) async {
    String? savedToken = await _getSharedPreferences.execute('fcmToken');
    String? currentToken = await FirebaseMessaging.instance.getToken();

    if (currentToken != null && savedToken != currentToken) {
      await _notificationRepository.saveFcmToken(uid, currentToken);
      await _saveSharedPreferences.execute('fcmToken', currentToken);
    }
  }
}
