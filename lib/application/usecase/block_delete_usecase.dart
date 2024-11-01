import 'package:green_heart/application/interface/block_repository.dart';

class BlockDeleteUsecase {
  final BlockRepository _blockRepository;

  BlockDeleteUsecase(this._blockRepository);

  Future<void> execute(String uid, String blockedUid) async {
    await _blockRepository.deleteBlockByUid(uid, blockedUid);
  }
}
