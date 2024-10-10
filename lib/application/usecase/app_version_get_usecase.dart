import 'package:green_heart/application/interface/app_info_repository.dart';

class AppVersionGetUsecase {
  final AppInfoRepository _appInfoRepository;

  AppVersionGetUsecase(this._appInfoRepository);

  Future<String> execute() async {
    try {
      return await _appInfoRepository.getAppVersion();
    } catch (e) {
      throw Exception('アプリの情報を取得できませんでした。');
    }
  }
}
