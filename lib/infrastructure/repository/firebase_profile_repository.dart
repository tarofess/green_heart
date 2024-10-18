import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/profile_repository.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class FirebaseProfileRepository implements ProfileRepository {
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
  Future<void> saveProfile(String uid, Profile profile) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('profile').doc(uid);
      await docRef.set(profile.toJson());
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('プロフィールの保存に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<String> uploadImage(String uid, String path) async {
    try {
      File file = File(path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('image/profile/$uid/$fileName.jpg');
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
  Future<void> deleteImage(String url) async {
    try {
      if (await checkImageExists(url) == false) {
        return;
      }
      final ref = FirebaseStorage.instance.refFromURL(url);
      await ref.delete();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('プロフィール画像の削除に失敗しました。再度お試しください。');
    }
  }

  Future<bool> checkImageExists(String imagePath) async {
    final ref = FirebaseStorage.instance.ref().child(imagePath);
    try {
      await ref.getDownloadURL();
      return true;
    } catch (e) {
      if (e is FirebaseException && e.code == 'object-not-found') {
        return false;
      }
      return false;
    }
  }
}
