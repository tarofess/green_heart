import 'package:green_heart/domain/type/block.dart';

abstract class BlockRepository {
  Future<void> addBlock(String uid, Block block);
  Future<List<Block>> getBlockByUid(String uid);
  Future<List<Block>> getBlockedByOther(String uid);
  Future<void> deleteBlockByUid(String uid, String targetUid);
  Future<bool> checkIfBlocked(String uid, String targetUid);
}
