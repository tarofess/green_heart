import 'package:green_heart/application/interface/block_repository.dart';

class BlockCheckUsecase {
  final BlockRepository _blockRepository;

  BlockCheckUsecase(this._blockRepository);

  Future<bool> execute(String? currentUserId, String targetUserId) async {
    if (currentUserId == null) {
      throw Exception('ユーザーが存在しないのでブロックリストを取得できません。再度お試しください。');
    }

    return await _blockRepository.checkIfBlocked(currentUserId, targetUserId);
  }
}
