import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_heart/application/interface/profile_repository.dart';
import 'package:green_heart/domain/type/profile.dart';

class FirebaseProfileRepository implements ProfileRepository {
  // @override
  // Future<Profile> getProfile() async {}

  @override
  Future<void> saveProfile(Profile profile) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('profile').doc(profile.uid);
      await docRef.set(profile.toJson());
      print('プロフィールが正常に保存されました');
    } catch (e) {
      throw Exception('プロフィールの保存中にエラーが発生しました: $e');
    }
  }
}
