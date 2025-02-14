import 'package:hooks_riverpod/hooks_riverpod.dart';

class SelectedTabIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setSelectedIndex(int index) {
    state = index;
  }
}

final selectedTabIndexNotifierProvider =
    NotifierProvider<SelectedTabIndexNotifier, int>(
  () => SelectedTabIndexNotifier(),
);
