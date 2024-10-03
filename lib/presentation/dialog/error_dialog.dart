import 'package:flutter/material.dart';

Future<void> showErrorDialog({
  required BuildContext context,
  required String title,
  required String content,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        content: Text(content),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'はい',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      );
    },
  );
}
