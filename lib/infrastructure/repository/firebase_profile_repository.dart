import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/profile_repository.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/domain/util/date_util.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class FirebaseProfileRepository implements ProfileRepository {
  @override
  Future<Profile> saveProfile(
    String uid,
    String name,
    String birthday,
    String bio,
    String? imageUrl,
  ) async {
    try {
      final profile = Profile(
        uid: uid,
        name: name,
        birthday: DateUtil.convertToDateTime(birthday),
        bio: bio,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('profile').doc(uid);
      await docRef.set(profile.toJson());

      return profile;
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('プロフィールの保存に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<Profile?> getProfile(String uid) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('profile').doc(uid);
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        return Profile.fromJson(docSnapshot.data()!);
      } else {
        return null;
      }
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('プロフィールの取得に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<String?> uploadImage(String uid, String? path) async {
    try {
      if (path == null) return null;
      File file = File(path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String extension = path.split('.').last;
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('image/profile/$uid/$fileName.$extension');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('プロフィール画像のアップロードに失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> deleteProfile(String uid) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('profile').doc(uid);
      await docRef.delete();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('プロフィールの削除に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> deleteImage(String imageUrl) async {
    try {
      if (await checkImageExists(imageUrl) == false) {
        return;
      }
      final ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('プロフィール画像の削除に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<bool> checkImageExists(String imageUrl) async {
    final ref = FirebaseStorage.instance.refFromURL(imageUrl);
    try {
      await ref.getMetadata();
      return true;
    } catch (e) {
      if (e is FirebaseException && e.code == 'object-not-found') {
        return false;
      }
      return false;
    }
  }
}
