import 'package:green_heart/application/interface/init_service.dart';

class FirebaseInitUsecase {
  final InitService _initService;

  FirebaseInitUsecase(this._initService);

  Future<void> execute() async {
    await _initService.initialize();
  }
}
