import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<String?> showReportDialog(BuildContext context) async {
  final reportTextController = TextEditingController();

  return await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              '不適切な内容を通報',
              style: TextStyle(fontSize: 24.sp),
            ),
            content: TextField(
              style: TextStyle(fontSize: 16.sp),
              controller: reportTextController,
              decoration: const InputDecoration(
                hintText: '通報の理由を入力してください',
              ),
              maxLines: null,
              onChanged: (value) {
                setState(() {});
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                child: Text(
                  'キャンセル',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
              ElevatedButton(
                onPressed: reportTextController.text.isNotEmpty
                    ? () => Navigator.of(context).pop(reportTextController.text)
                    : null,
                child: Text(
                  '通報',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
