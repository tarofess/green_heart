import 'package:green_heart/application/interface/file_repository.dart';

class AppInfoReadTextFileUsecase {
  final FileRepository _historyRepository;

  AppInfoReadTextFileUsecase(this._historyRepository);

  Future<String?> execute(String fileName) async {
    try {
      return await _historyRepository.readFileText(fileName);
    } catch (e) {
      throw Exception('ファイルの読み込みに失敗しました。');
    }
  }
}
