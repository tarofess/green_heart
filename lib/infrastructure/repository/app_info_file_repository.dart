import 'package:flutter/services.dart';

import 'package:green_heart/application/interface/file_repository.dart';

class AppInfoFileRepository implements FileRepository {
  @override
  Future<String?> readFileText(String fileName) async {
    return await rootBundle.loadString('assets/$fileName');
  }
}
