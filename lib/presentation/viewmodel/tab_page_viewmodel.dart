import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/presentation/page/home_page.dart';
import 'package:green_heart/presentation/page/timeline_page.dart';

class TabPageViewModel {
  final List<Widget> _pages = [
    const HomePage(),
    const TimelinePage(),
  ];
  List<Widget> get pages => _pages;
}

final tabPageViewModelProvider = Provider(
  (ref) => TabPageViewModel(),
);
