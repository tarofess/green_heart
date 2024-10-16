import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:green_heart/application/interface/profile_repository.dart';
import 'package:green_heart/domain/type/profile.dart';

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
    } on TimeoutException {
      throw Exception('処理がタイムアウトしました。通信環境をご確認ください。');
    } on SocketException {
      throw Exception('ネットワーク接続エラーが発生しました。インターネット接続をご確認ください。');
    } on HttpException {
      throw Exception('HTTPエラーが発生しました。しばらくしてから再度お試しください。');
    } on FormatException {
      throw Exception('データの形式が正しくありません。アプリを更新してください。');
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'permission-denied':
          throw Exception('アクセス権限がありません。');
        case 'not-found':
          throw Exception('プロフィールが見つかりません。');
        case 'unavailable':
          throw Exception('サービスが一時的に利用できません。しばらくしてから再度お試しください。');
        default:
          throw Exception('Firebaseエラーが発生しました: ${e.message}');
      }
    } catch (e) {
      throw Exception('予期せぬエラーが発生しました。サポートにお問い合わせください。');
    }
  }

  @override
  Future<void> saveProfile(String uid, Profile profile) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('profile').doc(uid);
      await docRef.set(profile.toJson());
    } on TimeoutException {
      throw Exception('処理がタイムアウトしました。通信環境をご確認ください。');
    } on SocketException {
      throw Exception('ネットワーク接続エラーが発生しました。インターネット接続をご確認ください。');
    } on HttpException {
      throw Exception('HTTPエラーが発生しました。しばらくしてから再度お試しください。');
    } on FormatException {
      throw Exception('データの形式が正しくありません。アプリを更新してください。');
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'permission-denied':
          throw Exception('プロフィールの保存権限がありません。');
        case 'unavailable':
          throw Exception('サービスが一時的に利用できません。しばらくしてから再度お試しください。');
        case 'unauthenticated':
          throw Exception('認証エラーが発生しました。再度ログインしてください。');
        default:
          throw Exception('Firebaseエラーが発生しました: ${e.message}');
      }
    } catch (e) {
      throw Exception('予期せぬエラーが発生しました。サポートにお問い合わせください。');
    }
  }

  @override
  Future<String> uploadImage(String uid, String path) async {
    File file = File(path);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('image/profile/$uid/$fileName.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}
