import 'package:green_heart/application/interface/init_service.dart';

class FirebaseInitUsecase {
  final InitService _initService;

  FirebaseInitUsecase(this._initService);

  Future<void> execute() async {
    try {
      await _initService.initialize();
    } catch (e) {
      throw Exception('Firebaseの初期化に失敗しました。再度お試しください。');
    }
  }
}
