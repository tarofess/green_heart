import 'package:green_heart/application/interface/file_service.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class AppInfoReadTextFileUsecase {
  final FileService _historyService;

  AppInfoReadTextFileUsecase(this._historyService);

  Future<String?> execute(String fileName) async {
    try {
      return await _historyService.readFileText(fileName);
    } catch (e, stackTrace) {
      await ExceptionHandler.handleException(e, stackTrace);
      return null;
    }
  }
}
