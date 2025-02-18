import 'package:green_heart/application/state/search_post_scroll_state_notifier.dart';
import 'package:green_heart/application/state/timeline_scroll_state_notifier.dart';
import 'package:green_heart/application/state/user_post_scroll_state_notifier.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/domain/type/search_post_scroll_state.dart';
import 'package:green_heart/domain/type/timeline_scroll_state.dart';
import 'package:green_heart/domain/type/user_post_scroll_state.dart';

abstract class PostRepository {
  Future<Post> addPost(
    String uid,
    String content,
    List<String> imageUrls,
    String userName,
    String? userImage,
    DateTime selectedDay,
  );
  Future<List<Post>> getDiaryPostsByUid(
    String uid,
    UserPostScrollState userPostScrollState,
    UserPostScrollStateNotifier userPostScrollStateNotifier,
  );
  Future<List<Post>> getTimelinePosts(
    TimeLineScrollState timeLineScrollState,
    TimelineScrollStateNotifier timelineScrollStateNotifier,
  );
  Future<List<Post>> getPostsBySearchWord(
    String searchWord,
    String? uid,
    SearchPostScrollState searchPostScrollState,
    SearchPostScrollStateNotifier searchPostScrollStateNotifier,
  );
  Future<List<Post>> getPostById(String postId);
  Future<List<String>> uploadImages(String uid, List<String> paths);
  Future<void> deletePost(String postId);
}
