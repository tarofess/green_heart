import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/domain/type/post_with_profile.dart';

class TimelineGetUsecase {
  final PostRepository _repository;

  TimelineGetUsecase(this._repository);

  Future<List<PostWithProfile>> execute() {
    return _repository.getAllPosts();
  }
}
