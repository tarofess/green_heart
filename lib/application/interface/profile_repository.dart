import 'package:green_heart/domain/type/profile.dart';

abstract class ProfileRepository {
  // Future<Profile> getProfile();
  Future<void> saveProfile(Profile profile);
}
