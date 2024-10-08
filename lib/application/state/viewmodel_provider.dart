import 'package:green_heart/application/viewmodel/profile_edit_page_viewmodel.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final profileEditPageViewModelProvider = Provider(
  (ref) => ProfileEditPageViewModel(),
);
