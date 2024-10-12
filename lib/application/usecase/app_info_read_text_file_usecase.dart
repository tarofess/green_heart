import 'package:green_heart/application/interface/file_service.dart';

class AppInfoReadTextFileUsecase {
  final FileService _historyService;

  AppInfoReadTextFileUsecase(this._historyService);

  Future<String?> execute(String fileName) async {
    try {
      return await _historyService.readFileText(fileName);
    } catch (e) {
      throw Exception('ファイルの読み込みに失敗しました。');
    }
  }
}
