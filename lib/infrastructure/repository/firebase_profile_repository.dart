import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/profile_repository.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class FirebaseProfileRepository implements ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _timeoutSeconds = 15;

  @override
  Future<Profile> saveProfile(Profile profile) async {
    try {
      final docRef = _firestore.collection('profile').doc(profile.uid);
      final docSnapshot =
          await docRef.get().timeout(Duration(seconds: _timeoutSeconds));
      if (docSnapshot.exists) {
        profile = profile.copyWith(
          createdAt: DateTime.parse(docSnapshot['createdAt']),
        );
      } else {
        profile = profile.copyWith(
          createdAt: DateTime.now(),
        );
      }

      await docRef
          .set(profile.toJson())
          .timeout(Duration(seconds: _timeoutSeconds));

      return profile;
    } catch (e, stackTrace) {
      if (e is TimeoutException) {
        return profile;
      }
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('プロフィールの保存に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<Profile?> getProfileByUid(String uid) async {
    try {
      final docRef = _firestore.collection('profile').doc(uid);
      final docSnapshot =
          await docRef.get().timeout(Duration(seconds: _timeoutSeconds));
      if (docSnapshot.exists) {
        return Profile.fromJson(docSnapshot.data()!);
      }
      return null;
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('プロフィールの取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<String?> uploadImage(String uid, String? path) async {
    try {
      if (path == null) return null;

      ListResult result = await FirebaseStorage.instance
          .ref()
          .child('image/profile/$uid')
          .listAll()
          .timeout(Duration(seconds: _timeoutSeconds));
      for (var item in result.items) {
        await item.delete().timeout(Duration(seconds: _timeoutSeconds));
      }

      File file = File(path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String extension = path.split('.').last;
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('image/profile/$uid/$fileName.$extension');
      await ref.putFile(file).timeout(Duration(seconds: _timeoutSeconds));
      return await ref
          .getDownloadURL()
          .timeout(Duration(seconds: _timeoutSeconds));
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('プロフィール画像のアップロードに失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> deleteImage(String? imageUrl) async {
    if (imageUrl == null) return;
    try {
      if (await checkImageExists(imageUrl) == false) {
        return;
      }
      final ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete().timeout(Duration(seconds: _timeoutSeconds));
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('プロフィール画像の削除に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<bool> checkImageExists(String imageUrl) async {
    final ref = FirebaseStorage.instance.refFromURL(imageUrl);
    try {
      await ref.getMetadata().timeout(Duration(seconds: _timeoutSeconds));
      return true;
    } catch (e) {
      if (e is FirebaseException && e.code == 'object-not-found') {
        return false;
      }
      return false;
    }
  }
}
