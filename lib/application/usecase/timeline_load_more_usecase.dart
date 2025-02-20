import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/application/state/timeline_notifier.dart';
import 'package:green_heart/domain/type/result.dart';
import 'package:green_heart/domain/type/timeline_scroll_state.dart';

class TimelineLoadMoreUsecase {
  final PostRepository _repository;
  final TimelineNotifier _timelineNotifier;
  final TimeLineScrollState _timeLineScrollState;

  TimelineLoadMoreUsecase(
    this._repository,
    this._timelineNotifier,
    this._timeLineScrollState,
  );

  Future<Result> execute() async {
    try {
      if (!_timeLineScrollState.hasMore) return const Success();

      final posts = await _repository.getTimelinePosts();
      await _timelineNotifier.loadMore(posts);

      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
