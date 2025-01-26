import 'package:green_heart/application/interface/block_repository.dart';
import 'package:green_heart/application/state/block_notifier.dart';
import 'package:green_heart/domain/type/block.dart';
import 'package:green_heart/domain/type/result.dart';

class BlockAddUsecase {
  final BlockRepository _blockRepository;
  final BlockNotifier _blockNotifier;

  BlockAddUsecase(this._blockRepository, this._blockNotifier);

  Future<Result> execute(String? myUid, String? targetUid) async {
    try {
      if (myUid == null || targetUid == null) {
        return const Failure('ユーザーが存在しないのでブロックリストを取得できません。再度お試しください。');
      }

      final newBlock = Block(
        uid: myUid,
        blockedUid: targetUid,
        blockedAt: DateTime.now(),
      );

      await _blockRepository.addBlock(newBlock);
      await _blockNotifier.addBlock(targetUid, newBlock);

      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
