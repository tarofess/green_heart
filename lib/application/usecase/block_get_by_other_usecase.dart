import 'package:green_heart/application/interface/block_repository.dart';
import 'package:green_heart/domain/type/block.dart';

class BlockGetByOtherUseCase {
  final BlockRepository _blockRepository;

  BlockGetByOtherUseCase(this._blockRepository);

  Future<List<Block>> execute(String uid) async {
    return await _blockRepository.getBlockedByOther(uid);
  }
}
