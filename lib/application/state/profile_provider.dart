import 'package:green_heart/application/usecase/profile_save_usecase.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/infrastructure/repository/firebase_profile_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final profileProvider = Provider.family<ProfileSaveUsecase, Profile>(
  (ref, profile) => ProfileSaveUsecase(FirebaseProfileRepository(), profile),
);
