import 'package:flutter/services.dart';

import 'package:green_heart/application/interface/file_repository.dart';

class UpdateHistoryFileRepository implements FileRepository {
  @override
  Future<String?> getFileText() async {
    return await rootBundle.loadString('assets/update_history.txt');
  }
}
