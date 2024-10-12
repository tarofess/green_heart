import 'package:flutter/services.dart';

import 'package:green_heart/application/interface/file_service.dart';

class AppInfoFileService implements FileService {
  @override
  Future<String?> readFileText(String fileName) async {
    return await rootBundle.loadString('assets/$fileName');
  }
}
