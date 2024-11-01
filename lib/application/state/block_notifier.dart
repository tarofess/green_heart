import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/block_di.dart';
import 'package:green_heart/domain/type/block.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';

class BlockNotifier extends AsyncNotifier<List<Block>> {
  @override
  Future<List<Block>> build() async {
    final uid = ref.watch(authStateProvider).value?.uid;
    if (uid == null) {
      throw Exception('ユーザーが存在しないのでブロックリストを取得できません。再度お試しください。');
    }
    final blocks = await ref.read(blockGetUsecaseProvider).execute(uid);
    return blocks;
  }

  Future<void> addBlock(String blockedUid) async {
    final uid = ref.watch(authStateProvider).value?.uid;
    if (uid == null) {
      throw Exception('ユーザーが存在しないのでブロックリストを取得できません。再度お試しください。');
    }

    final newBlock =
        await ref.read(blockAddUsecaseProvider).execute(uid, blockedUid);

    state.whenData((currentBlocks) {
      state = AsyncData([...currentBlocks, newBlock]);
    });
  }

  Future<void> deleteBlock(String blockedUid) async {
    final uid = ref.watch(authStateProvider).value?.uid;
    if (uid == null) {
      throw Exception('ユーザーが存在しないのでブロックリストを取得できません。再度お試しください。');
    }

    await ref.read(blockDeleteUsecaseProvider).execute(uid, blockedUid);

    state.whenData((currentBlocks) {
      final newBlocks = currentBlocks
          .where((block) => block.uid != uid && block.blockedUid != blockedUid)
          .toList();
      state = AsyncData(newBlocks);
    });
  }
}

final blockNotifierProvider = AsyncNotifierProvider<BlockNotifier, List<Block>>(
  () => BlockNotifier(),
);
