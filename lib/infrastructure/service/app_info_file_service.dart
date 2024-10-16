import 'package:flutter/services.dart';

import 'package:green_heart/application/interface/file_service.dart';

class AppInfoFileService implements FileService {
  @override
  Future<String?> readFileText(String fileName) async {
    try {
      return await rootBundle.loadString('assets/$fileName');
    } catch (e) {
      throw Exception('ファイルの読み込みに失敗しました。');
    }
  }
}
