import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData createDefaultTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
    fontFamily: 'MPLUSRounded1c-Regular',
    useMaterial3: true,
    appBarTheme: AppBarTheme(toolbarHeight: 58.h),
    textTheme: TextTheme(
      headlineLarge: TextStyle(fontSize: 40.sp),
      headlineMedium: TextStyle(fontSize: 34.sp),
      headlineSmall: TextStyle(fontSize: 26.sp),
      titleLarge: TextStyle(fontSize: 22.sp),
      titleMedium: TextStyle(fontSize: 20.sp),
      titleSmall: TextStyle(fontSize: 18.sp),
      bodyLarge: TextStyle(fontSize: 20.sp),
      bodyMedium: TextStyle(fontSize: 16.sp),
      bodySmall: TextStyle(fontSize: 14.sp),
      labelLarge: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      labelMedium: TextStyle(fontSize: 14.sp),
      labelSmall: TextStyle(fontSize: 12.sp),
    ),
  );
}
