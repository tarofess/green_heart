import 'package:green_heart/application/di/block_di.dart';
import 'package:green_heart/domain/type/block.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BlockNotifier extends FamilyAsyncNotifier<List<Block>, String?> {
  @override
  Future<List<Block>> build(String? arg) async {
    if (arg == null) {
      throw Exception('ユーザーが存在しないのでブロックリストを取得できません。再度お試しください。');
    }
    final blocks = await ref.read(blockGetUsecaseProvider).execute(arg);
    return blocks;
  }

  Future<void> addBlock(String uid, String blockedUid) async {
    final newBlock =
        await ref.read(blockAddUsecaseProvider).execute(uid, blockedUid);

    state.whenData((currentBlocks) {
      state = AsyncData([...currentBlocks, newBlock]);
    });
  }

  Future<void> deleteBlock(String uid, String blockedUid) async {
    await ref.read(blockDeleteUsecaseProvider).execute(uid, blockedUid);

    state.whenData((currentBlocks) {
      final newBlocks = currentBlocks
          .where((block) => block.uid != uid && block.blockedUid != blockedUid)
          .toList();
      state = AsyncData(newBlocks);
    });
  }
}

final blockNotifierProvider =
    AsyncNotifierProviderFamily<BlockNotifier, List<Block>, String?>(
        BlockNotifier.new);
