import 'package:green_heart/application/state/timeline_scroll_state_notifier.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/domain/type/timeline_scroll_state.dart';

abstract class PostRepository {
  Future<List<Post>> getPostsByUid(String uid);
  Future<List<Post>> getTimelinePosts(TimeLineScrollState timeLineScrollState,
      TimelineScrollStateNotifier timelineScrollStateNotifier);
  Future<Post> uploadPost(String uid, String content, List<String> imageUrls);
  Future<List<String>> uploadImages(String uid, List<String> paths);
  Future<void> deletePost(String postId);
  Future<void> deleteAllPostsByUid(String uid);
  Future<void> deleteImages(List<String> imageUrls);
  Future<void> deleteAllImagesByUid(String uid);
}
