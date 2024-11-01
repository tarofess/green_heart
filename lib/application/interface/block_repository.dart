import 'package:green_heart/domain/type/block.dart';

abstract class BlockRepository {
  Future<Block> addBlock(String uid, String blockedUid);
  Future<List<Block>> getBlockByUid(String blockedUid);
  Future<void> deleteBlockByUid(String uid, String blockedUid);
}
