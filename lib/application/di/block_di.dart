import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/block_add_usecase.dart';
import 'package:green_heart/application/usecase/block_delete_usecase.dart';
import 'package:green_heart/application/usecase/block_get_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_block_repository.dart';
import 'package:green_heart/application/usecase/block_check_usecase.dart';
import 'package:green_heart/application/state/block_notifier.dart';
import 'package:green_heart/application/usecase/block_get_by_other_usecase.dart';

final blockGetUsecaseProvider = Provider<BlockGetUsecase>((ref) {
  return BlockGetUsecase(FirebaseBlockRepository());
});

final blockGetByOtherUsecaseProvider = Provider<BlockGetByOtherUseCase>((ref) {
  return BlockGetByOtherUseCase(FirebaseBlockRepository());
});

final blockAddUsecaseProvider = Provider<BlockAddUsecase>((ref) {
  ref.watch(blockNotifierProvider);
  return BlockAddUsecase(
    FirebaseBlockRepository(),
    ref.read(blockNotifierProvider.notifier),
  );
});

final blockDeleteUsecaseProvider = Provider<BlockDeleteUsecase>((ref) {
  return BlockDeleteUsecase(
    FirebaseBlockRepository(),
    ref.read(blockNotifierProvider.notifier),
  );
});

final blockCheckUsecaseProvider = Provider<BlockCheckUsecase>((ref) {
  return BlockCheckUsecase(FirebaseBlockRepository());
});
