import 'dart:async';
import 'dart:io';
import 'package:algoliasearch/algoliasearch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';
import 'package:green_heart/application/state/timeline_scroll_state_notifier.dart';
import 'package:green_heart/application/state/user_post_scroll_state_notifier.dart';
import 'package:green_heart/env/env.dart';
import 'package:green_heart/application/state/search_post_scroll_state_notifier.dart';

class FirebasePostRepository implements PostRepository {
  final Ref _ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _timeoutSeconds = 15;
  final int _pageSize = 12;
  final int _diaryPageSize = 32;

  FirebasePostRepository(this._ref);

  @override
  Future<Post> addPost(
    String postId,
    String uid,
    String content,
    List<String> imageUrls,
    String userName,
    String? userImage,
    DateTime selectedDay,
  ) async {
    final post = Post(
      id: postId,
      uid: uid,
      content: content,
      imageUrls: imageUrls,
      userName: userName,
      userImage: userImage,
      releaseDate: selectedDay,
      createdAt: DateTime.now(),
    );

    try {
      await _firestore
          .collection('post')
          .doc(postId)
          .set(post.toJson())
          .timeout(Duration(seconds: _timeoutSeconds));
      return post;
    } catch (e, stackTrace) {
      if (e is TimeoutException) return post;

      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('投稿に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<List<Post>> getDiaryPostsByUid(String uid) async {
    final userPostScrollState =
        _ref.read(userPostScrollStateNotifierProvider(uid));
    final userPostScrollStateNotifier =
        _ref.read(userPostScrollStateNotifierProvider(uid).notifier);

    try {
      if (!userPostScrollState.hasMore) return [];

      Query query = _firestore
          .collection('post')
          .where('uid', isEqualTo: uid)
          .orderBy('releaseDate', descending: true)
          .limit(_diaryPageSize);

      if (userPostScrollState.lastDocument != null) {
        query = query.startAfterDocument(userPostScrollState.lastDocument!);
      }

      final querySnapshot =
          await query.get().timeout(Duration(seconds: _timeoutSeconds));

      if (querySnapshot.docs.isEmpty ||
          querySnapshot.docs.length < _diaryPageSize) {
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
  Future<List<Post>> getTimelinePosts() async {
    final timeLineScrollState = _ref.read(timelineScrollStateNotifierProvider);
    final timelineScrollStateNotifier =
        _ref.read(timelineScrollStateNotifierProvider.notifier);

    try {
      if (!timeLineScrollState.hasMore) return [];

      Query query = _firestore
          .collection('post')
          .orderBy('createdAt', descending: true)
          .limit(_pageSize);

      if (timeLineScrollState.lastDocument != null) {
        query = query.startAfterDocument(timeLineScrollState.lastDocument!);
      }

      final querySnapshot =
          await query.get().timeout(Duration(seconds: _timeoutSeconds));

      if (querySnapshot.docs.isEmpty || querySnapshot.docs.length < _pageSize) {
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
  Future<List<Post>> getPostsBySearchWord(
    String searchWord,
    String? uid,
  ) async {
    final searchPostScrollState =
        _ref.read(searchPostScrollStateNotifierProvider);
    final searchPostScrollStateNotifier =
        _ref.read(searchPostScrollStateNotifierProvider.notifier);

    try {
      if (!searchPostScrollState.hasMore) return [];

      final client = SearchClient(
        appId: Env.appId,
        apiKey: Env.apiKey,
      );

      SearchForHits queryHits;
      if (uid == null) {
        queryHits = SearchForHits(
          indexName: 'post',
          query: searchWord,
          hitsPerPage: _pageSize,
          page: searchPostScrollState.currentPage,
        );
      } else {
        queryHits = SearchForHits(
          indexName: 'post',
          query: searchWord,
          hitsPerPage: _pageSize,
          filters: 'uid:$uid',
          page: searchPostScrollState.currentPage,
        );
      }

      final responseHits = await client
          .searchIndex(request: queryHits)
          .timeout(Duration(seconds: _timeoutSeconds));

      if (responseHits.hits.isEmpty) {
        searchPostScrollStateNotifier.updateHasMore(false);
      } else {
        searchPostScrollStateNotifier.updateCurrentPage(
          searchPostScrollState.currentPage + 1,
        );
      }

      return responseHits.hits
          .map((hit) => Post.fromJson(hit as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('投稿の検索に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<List<Post>> getPostById(String postId) async {
    try {
      final docSnapshot = await _firestore
          .collection('post')
          .doc(postId)
          .get()
          .timeout(Duration(seconds: _timeoutSeconds));

      if (!docSnapshot.exists || docSnapshot.data() == null) {
        return [];
      }

      return [Post.fromJson(docSnapshot.data() as Map<String, dynamic>)];
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('投稿の取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<(String postId, List<String>)> uploadImages(
      String uid, List<String> paths) async {
    try {
      final postId = _firestore.collection('post').doc().id;

      final uploadTasks = paths.map((path) async {
        File file = File(path);
        String fileName = const Uuid().v4();
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('image/post/$postId/$fileName.jpg');
        await ref.putFile(file).timeout(Duration(seconds: _timeoutSeconds));
        return await ref
            .getDownloadURL()
            .timeout(Duration(seconds: _timeoutSeconds));
      });

      final urls = await Future.wait(uploadTasks);
      return (postId, urls);
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('画像のアップロードに失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await _firestore
          .collection('post')
          .doc(postId)
          .delete()
          .timeout(Duration(seconds: _timeoutSeconds));
    } catch (e, stackTrace) {
      if (e is TimeoutException) {
        return;
      }
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('投稿の削除に失敗しました。再度お試しください。');
    }
  }
}
