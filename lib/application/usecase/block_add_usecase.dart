import 'package:green_heart/application/interface/block_repository.dart';
import 'package:green_heart/domain/type/block.dart';

class BlockAddUsecase {
  final BlockRepository _blockRepository;

  BlockAddUsecase(this._blockRepository);

  Future<Block> execute(String uid, String blockedUid) async {
    return await _blockRepository.addBlock(uid, blockedUid);
  }
}
