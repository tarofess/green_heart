import 'package:flutter/material.dart';
import 'package:green_heart/presentation/dialog/base_dialog.dart';

Future<void> showMessageDialog({
  required BuildContext context,
  required String title,
  required String content,
}) async {
  await showSingleButtonDialogBase(
    context: context,
    title: title,
    content: content,
    buttonText: 'はい',
    handleButtonPress: (dialogContext) => Navigator.of(dialogContext).pop(),
  );
}
