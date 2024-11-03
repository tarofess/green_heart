import 'package:green_heart/domain/type/block.dart';

abstract class BlockRepository {
  Future<Block> addBlock(Block block);
  Future<List<Block>> getBlockByUid(String uid);
  Future<void> deleteBlockByUid(String uid, String blockedUid);
  Future<bool> checkIfBlocked(String currentUserId, String targetUserId);
}
