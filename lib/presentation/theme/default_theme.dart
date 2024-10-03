import 'package:flutter/material.dart';

ThemeData createDefaultTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
    fontFamily: 'MPLUSRounded1c-Regular',
    useMaterial3: true,
  );
}
