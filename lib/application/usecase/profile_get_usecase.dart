import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_heart/application/interface/profile_repository.dart';
import 'package:green_heart/domain/type/profile.dart';

class ProfileGetUsecase {
  final ProfileRepository _profileRepository;

  ProfileGetUsecase(this._profileRepository);

  Future<Profile?> execute(String uid) async {
    try {
      return await _profileRepository.getProfile(uid);
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
}
