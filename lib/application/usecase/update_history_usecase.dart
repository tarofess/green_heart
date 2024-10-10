import 'package:green_heart/application/interface/file_repository.dart';

class UpdateHistoryUsecase {
  final FileRepository _historyRepository;

  UpdateHistoryUsecase(this._historyRepository);

  Future<String?> execute() async {
    try {
      return await _historyRepository.getFileText();
    } catch (e) {
      throw Exception('ファイルの読み込みに失敗しました。');
    }
  }
}
