import 'package:firebase_auth/firebase_auth.dart';

import 'package:green_heart/application/interface/block_repository.dart';

class BlockDeleteAllUsecase {
  final BlockRepository _blockRepository;

  BlockDeleteAllUsecase(this._blockRepository);

  Future<void> execute(User user) async {
    return _blockRepository.deleteAllBlockByUid(user.uid);
  }
}
