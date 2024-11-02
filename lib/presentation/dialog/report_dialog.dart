import 'package:flutter/material.dart';

Future<String?> showReportDialog(BuildContext context) async {
  final reportTextController = TextEditingController();

  return await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('不適切な内容を通報'),
            content: TextField(
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
                child: const Text('キャンセル'),
              ),
              ElevatedButton(
                onPressed: reportTextController.text.isNotEmpty
                    ? () {
                        Navigator.of(context).pop(reportTextController.text);
                      }
                    : null,
                child: const Text('通報'),
              ),
            ],
          );
        },
      );
    },
  );
}
