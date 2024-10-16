import 'package:flutter/services.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/file_service.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class AppInfoFileService implements FileService {
  @override
  Future<String?> readFileText(String fileName) async {
    try {
      return await rootBundle.loadString('assets/$fileName');
    } catch (e) {
      final exception = ExceptionHandler.handleException(e);
      throw exception ?? AppException('アプリ情報の読み込みに失敗しました。');
    }
  }
}
