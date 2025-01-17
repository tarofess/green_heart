import 'package:firebase_auth/firebase_auth.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/block_repository.dart';

class BlockDeleteAllUsecase {
  final BlockRepository _blockRepository;

  BlockDeleteAllUsecase(this._blockRepository);

  Future<void> execute(User user) async {
    try {
      return _blockRepository.deleteAllBlockByUid(user.uid);
    } catch (e) {
      throw AppException('ブロックの削除に失敗しました。再度お試しください。');
    }
  }
}
