import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/block_di.dart';
import 'package:green_heart/domain/type/block.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/domain/type/block_data.dart';

class BlockNotifier extends AsyncNotifier<List<BlockData>> {
  @override
  Future<List<BlockData>> build() async {
    final uid = ref.watch(authStateProvider).value?.uid;
    if (uid == null) {
      throw Exception('ユーザーが存在しないのでブロックリストを取得できません。再度お試しください。');
    }
    final blocks = await ref.read(blockGetUsecaseProvider).execute(uid);
    final blockDataList = await _createBlockData(blocks);
    return blockDataList;
  }

  Future<List<BlockData>> _createBlockData(List<Block> blocks) async {
    List<BlockData> blockData = [];

    final task = blocks.map((block) async {
      final profile = await ref.read(profileGetUsecaseProvider).execute(
            block.blockedUid,
          );
      return BlockData(
        block: block,
        profile: profile,
      );
    }).toList();

    blockData = await Future.wait(task);
    return blockData;
  }

  Future<void> addBlock(String targetUid, Block newBlock) async {
    final profile =
        await ref.read(profileGetUsecaseProvider).execute(targetUid);

    state.whenData((currentBlocks) {
      final updatedBlock = List<BlockData>.from(currentBlocks)
        ..add(BlockData(
          block: newBlock,
          profile: profile,
        ));
      state = AsyncValue.data(updatedBlock);
    });
  }

  void deleteBlock(String myUid, String targetUid) async {
    state.whenData((currentBlocks) {
      final updatedBlock = currentBlocks
          .where((blockData) =>
              blockData.block.uid != myUid &&
              blockData.block.blockedUid != targetUid)
          .toList();
      state = AsyncValue.data(updatedBlock);
    });
  }

  Future<void> deleteAllBlocks(User user) async {
    await ref.read(blockDeleteAllUsecaseProvider).execute(user);

    state.whenData((blockdataList) {
      final updatedBlockData = blockdataList
          .where((blockdata) => blockdata.block.uid != user.uid)
          .toList();
      state = AsyncValue.data(updatedBlockData);
    });
  }
}

final blockNotifierProvider =
    AsyncNotifierProvider<BlockNotifier, List<BlockData>>(
  () => BlockNotifier(),
);
