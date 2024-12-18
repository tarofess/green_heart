import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/block_add_usecase.dart';
import 'package:green_heart/application/usecase/block_delete_usecase.dart';
import 'package:green_heart/application/usecase/block_get_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_block_repository.dart';
import 'package:green_heart/application/usecase/block_check_usecase.dart';
import 'package:green_heart/application/usecase/block_delete_all_usecase.dart';

final blockGetUsecaseProvider = Provider<BlockGetUsecase>((ref) {
  return BlockGetUsecase(FirebaseBlockRepository());
});

final blockAddUsecaseProvider = Provider<BlockAddUsecase>((ref) {
  return BlockAddUsecase(FirebaseBlockRepository());
});

final blockDeleteUsecaseProvider = Provider<BlockDeleteUsecase>((ref) {
  return BlockDeleteUsecase(FirebaseBlockRepository());
});

final blockDeleteAllUsecaseProvider = Provider<BlockDeleteAllUsecase>((ref) {
  return BlockDeleteAllUsecase(FirebaseBlockRepository());
});

final blockCheckUsecaseProvider = Provider<BlockCheckUsecase>((ref) {
  return BlockCheckUsecase(FirebaseBlockRepository());
});
