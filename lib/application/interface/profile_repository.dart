import 'package:green_heart/domain/type/profile.dart';

abstract class ProfileRepository {
  Future<Profile?> getProfile(String uid);
  Future<void> saveProfile(String uid, Profile profile);
}
