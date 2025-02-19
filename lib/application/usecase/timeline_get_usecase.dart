import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/domain/type/post.dart';

class TimelineGetUsecase {
  final PostRepository _repository;

  TimelineGetUsecase(this._repository);

  Future<List<Post>> execute() async {
    return await _repository.getTimelinePosts();
  }
}
