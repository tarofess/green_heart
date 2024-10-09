import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/domain/type/profile.dart';

final profileNotifierProvider =
    AsyncNotifierProvider<ProfileNotifier, Profile?>(() => ProfileNotifier());
