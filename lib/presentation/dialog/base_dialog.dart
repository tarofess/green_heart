import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showSingleButtonDialogBase({
  required BuildContext context,
  required String title,
  required String content,
  required String buttonText,
  required Function(BuildContext dialogContext) handleButtonPress,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(fontSize: 24.sp),
          textAlign: TextAlign.center,
        ),
        content: Text(
          content,
          style: TextStyle(fontSize: 16.sp),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () => handleButtonPress(dialogContext),
              child: Text(
                buttonText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
