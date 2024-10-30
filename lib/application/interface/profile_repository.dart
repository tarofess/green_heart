import 'package:green_heart/domain/type/profile.dart';

abstract class ProfileRepository {
  Future<Profile?> getProfile(String uid);
  Future<Profile> saveProfile(
      String uid, String name, String birthday, String bio, String? imageUrl);
  Future<String> uploadImage(String uid, String path);
  Future<void> deleteProfile(String uid);
  Future<void> deleteImage(String imageUrl);
  Future<bool> checkImageExists(String imageUrl);
}
