import 'package:green_heart/application/interface/block_repository.dart';
import 'package:green_heart/application/state/block_notifier.dart';
import 'package:green_heart/domain/type/result.dart';

class BlockDeleteUsecase {
  final BlockRepository _blockRepository;
  final BlockNotifier _blockNotifier;

  BlockDeleteUsecase(this._blockRepository, this._blockNotifier);

  Future<Result> execute(String? myUid, String? targetUid) async {
    try {
      if (myUid == null || targetUid == null) {
        return const Failure('ユーザーが存在しないのでブロックリストを取得できません。再度お試しください。');
      }

      await _blockRepository.deleteBlockByUid(myUid, targetUid);
      _blockNotifier.deleteBlock(targetUid);

      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
