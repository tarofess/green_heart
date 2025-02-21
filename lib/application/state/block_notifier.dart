import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/block_di.dart';
import 'package:green_heart/domain/type/block.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';

class BlockNotifier extends AsyncNotifier<List<Block>> {
  @override
  Future<List<Block>> build() async {
    final uid = ref.watch(authStateProvider).value?.uid;
    if (uid == null) {
      throw Exception('ユーザー情報が取得できませんでした。再度お試しください。');
    }

    final blocks = await ref.read(blockGetUsecaseProvider).execute(uid);
    return blocks;
  }

  Future<void> addBlock(Block newBlock) async {
    state.whenData((currentBlocks) {
      state = AsyncValue.data([...currentBlocks, newBlock]);
    });
  }

  void deleteBlock(String targetUid) {
    state.whenData((currentBlocks) {
      final updatedBlock = currentBlocks
          .where((blocks) => blocks.targetUid != targetUid)
          .toList();
      state = AsyncValue.data(updatedBlock);
    });
  }
}

final blockNotifierProvider = AsyncNotifierProvider<BlockNotifier, List<Block>>(
  () => BlockNotifier(),
);
