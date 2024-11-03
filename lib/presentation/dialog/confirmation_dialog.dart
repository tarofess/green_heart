import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String positiveButtonText,
  required String negativeButtonText,
}) async {
  final result = await showDialog(
    context: context,
    builder: (BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    negativeButtonText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.h),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    positiveButtonText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );

  return result ?? false;
}
