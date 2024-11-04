import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';
import 'package:green_heart/application/state/timeline_scroll_state_notifier.dart';
import 'package:green_heart/domain/type/timeline_scroll_state.dart';
import 'package:green_heart/application/state/user_post_scroll_state_notifier.dart';
import 'package:green_heart/domain/type/user_post_scroll_state.dart';

class FirebasePostRepository implements PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Post> addPost(
    String uid,
    String content,
    List<String> imageUrls,
  ) async {
    try {
      final docRef = _firestore.collection('post').doc();

      final post = Post(
        id: docRef.id,
        uid: uid,
        content: content,
        imageUrls: imageUrls,
        createdAt: DateTime.now(),
      );

      await docRef.set(post.toJson());
      return post;
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('投稿に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<List<Post>> getPostsByUid(
    String uid,
    UserPostScrollState userPostScrollState,
    UserPostScrollStateNotifier userPostScrollStateNotifier,
  ) async {
    const int pageSize = 20;

    try {
      if (!userPostScrollState.hasMore) return [];

      Query query = _firestore
          .collection('post')
          .where('uid', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .limit(pageSize);

      if (userPostScrollState.lastDocument != null) {
        query = query.startAfterDocument(userPostScrollState.lastDocument!);
      }

      final querySnapshot = await query.get();
      if (querySnapshot.docs.isEmpty || querySnapshot.docs.length < pageSize) {
        userPostScrollStateNotifier.updateHasMore(false);
      }

      if (querySnapshot.docs.isNotEmpty) {
        userPostScrollStateNotifier.updateLastDocument(querySnapshot.docs.last);
      }

      return querySnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('投稿の取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<List<Post>> getTimelinePosts(
    TimeLineScrollState timeLineScrollState,
    TimelineScrollStateNotifier timelineScrollStateNotifier,
  ) async {
    const int pageSize = 20;

    try {
      if (!timeLineScrollState.hasMore) return [];

      Query query = _firestore
          .collection('post')
          .orderBy('createdAt', descending: true)
          .limit(pageSize);

      if (timeLineScrollState.lastDocument != null) {
        query = query.startAfterDocument(timeLineScrollState.lastDocument!);
      }

      final querySnapshot = await query.get();
      if (querySnapshot.docs.isEmpty || querySnapshot.docs.length < pageSize) {
        timelineScrollStateNotifier.updateHasMore(false);
      }

      if (querySnapshot.docs.isNotEmpty) {
        timelineScrollStateNotifier.updateLastDocument(querySnapshot.docs.last);
      }

      return querySnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('投稿の取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<List<String>> uploadImages(String uid, List<String> paths) async {
    try {
      final uploadTasks = paths.map((path) async {
        File file = File(path);
        String fileName = const Uuid().v4();
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('image/post/$uid/$fileName.jpg');
        await ref.putFile(file);
        return await ref.getDownloadURL();
      });

      final urls = await Future.wait(uploadTasks);
      return urls;
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('画像のアップロードに失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('post').doc(postId).delete();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('投稿の削除に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> deleteAllPostsByUid(String uid) async {
    try {
      final querySnapshot = await _firestore
          .collection('post')
          .where('uid', isEqualTo: uid)
          .get();
      for (final doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('投稿の削除に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> deleteImages(List<String> imageUrls) async {
    try {
      for (final url in imageUrls) {
        Reference ref = FirebaseStorage.instance.refFromURL(url);
        await ref.delete();
      }
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('画像アップロードのロールバック処理に失敗しました。');
    }
  }

  @override
  Future<void> deleteAllImagesByUid(String uid) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('image/post/$uid');
      final listResult = await ref.listAll();
      for (final item in listResult.items) {
        await item.delete();
      }
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('画像の削除に失敗しました。再度お試しください。');
    }
  }
}
