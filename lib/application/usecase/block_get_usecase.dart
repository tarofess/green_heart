import 'package:green_heart/application/interface/block_repository.dart';
import 'package:green_heart/domain/type/block.dart';

class BlockGetUsecase {
  final BlockRepository _blockRepository;

  BlockGetUsecase(this._blockRepository);

  Future<List<Block>> execute(String blockedUid) {
    return _blockRepository.getBlockByUid(blockedUid);
  }
}
