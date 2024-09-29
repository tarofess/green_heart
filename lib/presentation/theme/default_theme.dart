import 'package:flutter/material.dart';

ThemeData createDefaultTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
    fontFamily: 'MPLUSRounded1c-Regular',
    useMaterial3: true,
  );
}
