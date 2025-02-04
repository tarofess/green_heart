import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/application/state/timeline_scroll_state_notifier.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/domain/type/timeline_scroll_state.dart';

class TimelineGetUsecase {
  final PostRepository _repository;

  TimelineGetUsecase(this._repository);

  Future<List<Post>> execute(
    TimeLineScrollState timeLineScrollState,
    TimelineScrollStateNotifier timelineScrollStateNotifier,
  ) async {
    return await _repository.getTimelinePosts(
      timeLineScrollState,
      timelineScrollStateNotifier,
    );
  }
}
