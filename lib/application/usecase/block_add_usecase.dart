import 'package:green_heart/application/interface/block_repository.dart';
import 'package:green_heart/application/state/block_notifier.dart';
import 'package:green_heart/domain/type/block.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/domain/type/result.dart';

class BlockAddUsecase {
  final BlockRepository _blockRepository;
  final BlockNotifier _blockNotifier;

  BlockAddUsecase(this._blockRepository, this._blockNotifier);

  Future<Result> execute(
    String? uid,
    String? targetUid,
    Profile? profile,
  ) async {
    try {
      if (uid == null || targetUid == null || profile == null) {
        return const Failure('ユーザーが存在しないのでブロックリストを取得できません。再度お試しください。');
      }

      final newBlock = Block(
        uid: targetUid,
        userName: profile.name,
        userImage: profile.imageUrl,
        createdAt: DateTime.now(),
      );

      await _blockNotifier.addBlock(targetUid, newBlock);
      await _blockRepository.addBlock(uid, newBlock);

      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
