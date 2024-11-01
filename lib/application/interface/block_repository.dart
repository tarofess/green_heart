import 'package:green_heart/domain/type/block.dart';

abstract class BlockRepository {
  Future<Block> addBlock(String uid, String blockedUid);
  Future<List<Block>> getBlockByUid(String uid);
  Future<void> deleteBlockByUid(String uid, String blockedUid);
  Future<bool> checkIfBlocked(String currentUserId, String targetUserId);
}
