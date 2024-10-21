import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class FirebasePostRepository implements PostRepository {
  @override
  Future<List<Post>> getPostsByUid(String uid) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('post')
          .where('uid', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => Post.fromJson(doc.data()))
          .toList();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('投稿の取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<List<Post>> getAllPosts() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('post')
          .orderBy('createdAt', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => Post.fromJson(doc.data()))
          .toList();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('投稿の取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> uploadPost(Post post) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('post').doc();
      await docRef.set(post.toJson());
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
