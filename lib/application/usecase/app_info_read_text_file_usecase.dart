import 'package:green_heart/application/interface/file_service.dart';

class AppInfoReadTextFileUsecase {
  final FileService _historyService;

  AppInfoReadTextFileUsecase(this._historyService);

  Future<String?> execute(String fileName) async {
    return await _historyService.readFileText(fileName);
  }
}
