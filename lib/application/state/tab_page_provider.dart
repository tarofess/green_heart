import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/presentation/page/home_page.dart';
import 'package:green_heart/presentation/page/timeline_page.dart';

final tabPageProvider = Provider<List<Widget>>((ref) {
  final List<Widget> pages = [
    const HomePage(),
    const TimelinePage(),
  ];
  return pages;
});
