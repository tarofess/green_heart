import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/domain/type/post_with_profile.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class FirebasePostRepository implements PostRepository {
  @override
  Future<List<PostWithProfile>> getPostsByUid(String uid) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('post')
          .where('uid', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();

      List<PostWithProfile> postsWithProfiles = [];

      for (var doc in querySnapshot.docs) {
        Post post = Post.fromJson(doc.data());

        DocumentSnapshot profileSnapshot =
            await firestore.collection('profile').doc(post.uid).get();

        if (profileSnapshot.exists) {
          Profile profile =
              Profile.fromJson(profileSnapshot.data() as Map<String, dynamic>);

          postsWithProfiles.add(PostWithProfile(post: post, profile: profile));
        }
      }

      return postsWithProfiles;
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('投稿の取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<List<PostWithProfile>> getAllPosts() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('post')
          .orderBy('createdAt', descending: true)
          .get();
      List<PostWithProfile> postsWithProfiles = [];

      for (var doc in querySnapshot.docs) {
        Post post = Post.fromJson(doc.data());

        DocumentSnapshot profileSnapshot =
            await firestore.collection('profile').doc(post.uid).get();

        if (profileSnapshot.exists) {
          Profile profile =
              Profile.fromJson(profileSnapshot.data() as Map<String, dynamic>);

          postsWithProfiles.add(PostWithProfile(post: post, profile: profile));
        }
      }

      return postsWithProfiles;
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('投稿の取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<Post> uploadPost(
    String uid,
    String content,
    List<String> imageUrls,
  ) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('post').doc();

      final post = Post(
        id: docRef.id,
        uid: uid,
        content: content,
        imageUrls: imageUrls,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await docRef.set(post.toJson());
      return post;
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('投稿に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<List<String>> uploadImages(String uid, List<String> paths) async {
    try {
      List<String> urls = [];
      for (final path in paths) {
        File file = File(path);
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('image/post/$uid/$fileName.jpg');
        await ref.putFile(file);
        final url = await ref.getDownloadURL();
        urls.add(url);
      }
      return urls;
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('画像のアップロードに失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('post').doc(postId).delete();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('投稿の削除に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> deleteAllPostsByUid(String uid) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot =
          await firestore.collection('post').where('uid', isEqualTo: uid).get();
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
