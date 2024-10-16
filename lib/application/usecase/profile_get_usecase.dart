import 'dart:async';

import 'package:green_heart/application/interface/profile_repository.dart';
import 'package:green_heart/domain/type/profile.dart';

class ProfileGetUsecase {
  final ProfileRepository _profileRepository;

  ProfileGetUsecase(this._profileRepository);

  Future<Profile?> execute(String uid) async {
    return await _profileRepository.getProfile(uid);
  }
}
