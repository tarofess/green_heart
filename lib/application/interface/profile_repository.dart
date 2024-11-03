import 'package:green_heart/domain/type/profile.dart';

abstract class ProfileRepository {
  Future<Profile> saveProfile(Profile profile);
  Future<Profile?> getProfileByUid(String uid);
  Future<String?> uploadImage(String uid, String? path);
  Future<void> deleteProfile(String uid);
  Future<void> deleteImage(String imageUrl);
  Future<bool> checkImageExists(String imageUrl);
}
