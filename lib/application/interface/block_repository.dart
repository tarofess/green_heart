import 'package:green_heart/domain/type/block.dart';

abstract class BlockRepository {
  Future<void> addBlock(Block block);
  Future<List<Block>> getBlockByUid(String uid);
  Future<void> deleteBlockByUid(String uid, String blockedUid);
  Future<void> deleteAllBlockByUid(String uid);
  Future<bool> checkIfBlocked(String currentUserId, String targetUserId);
}
