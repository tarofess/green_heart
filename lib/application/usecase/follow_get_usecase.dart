import 'package:green_heart/application/interface/follow_repository.dart';
import 'package:green_heart/domain/type/follow.dart';

class FollowGetUsecase {
  final FollowRepository _repository;

  FollowGetUsecase(this._repository);

  Future<List<Follow>> execute(String uid) async {
    return await _repository.getFollows(uid);
  }
}
