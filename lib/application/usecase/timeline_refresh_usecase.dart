import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/application/state/timeline_notifier.dart';
import 'package:green_heart/application/state/timeline_scroll_state_notifier.dart';
import 'package:green_heart/domain/type/result.dart';

class TimelineRefreshUsecase {
  final PostRepository _repository;
  final TimelineNotifier _timelineNotifier;
  final TimelineScrollStateNotifier _timelineScrollStateNotifier;

  TimelineRefreshUsecase(
    this._repository,
    this._timelineNotifier,
    this._timelineScrollStateNotifier,
  );

  Future<Result> execute() async {
    try {
      _timelineScrollStateNotifier.reset();

      final posts = await _repository.getTimelinePosts();
      await _timelineNotifier.refresh(posts);

      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
