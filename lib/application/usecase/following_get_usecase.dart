import 'package:green_heart/application/interface/follow_repository.dart';
import 'package:green_heart/domain/type/follow.dart';

class FollowingGetUsecase {
  final FollowRepository _repository;

  FollowingGetUsecase(this._repository);

  Future<List<Follow>> execute(String uid) async {
    return await _repository.getFollowing(uid);
  }
}
