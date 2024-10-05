import 'package:cloud_firestore/cloud_firestore.dart';
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
    } catch (e) {
      throw Exception('プロフィールの取得中にエラーが発生しました。');
    }
  }

  @override
  Future<void> saveProfile(String uid, Profile profile) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('profile').doc(uid);
      await docRef.set(profile.toJson());
    } catch (e) {
      throw Exception('プロフィールの保存中にエラーが発生しました。');
    }
  }
}
