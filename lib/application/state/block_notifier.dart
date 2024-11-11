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
    final blockData = _createBlockData(blocks);
    return blockData;
  }

  Future<List<BlockData>> _createBlockData(List<Block> blocks) async {
    final blockDataList = blocks.map((block) async {
      final profile =
          await ref.read(profileGetUsecaseProvider).execute(block.blockedUid);
      return BlockData(
        block: block,
        profile: profile,
      );
    }).toList();

    return Future.wait(blockDataList);
  }

  Future<void> addBlock(String blockedUid) async {
    final uid = ref.watch(authStateProvider).value?.uid;
    if (uid == null) {
      throw Exception('ユーザーが存在しないのでブロックリストを取得できません。再度お試しください。');
    }

    final newBlock =
        await ref.read(blockAddUsecaseProvider).execute(uid, blockedUid);
    final profile =
        await ref.read(profileGetUsecaseProvider).execute(blockedUid);

    state.whenData((currentBlocks) {
      final updatedBlock = List<BlockData>.from(currentBlocks)
        ..add(BlockData(
          block: newBlock,
          profile: profile,
        ));
      state = AsyncValue.data(updatedBlock);
    });
  }

  Future<void> deleteBlock(String blockedUid) async {
    final uid = ref.watch(authStateProvider).value?.uid;
    if (uid == null) {
      throw Exception('ユーザーが存在しないのでブロックリストを取得できません。再度お試しください。');
    }

    await ref.read(blockDeleteUsecaseProvider).execute(uid, blockedUid);

    state.whenData((currentBlocks) {
      final updatedBlock = currentBlocks
          .where((blockData) =>
              blockData.block.uid != uid &&
              blockData.block.blockedUid != blockedUid)
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
