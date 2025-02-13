import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:green_heart/presentation/dialog/confirmation_dialog.dart';
import 'package:green_heart/presentation/dialog/message_dialog.dart';

class PermissionUtil {
  static Future<bool> requestCameraPermission(BuildContext context) async {
    final status = await Permission.camera.request();
    switch (status) {
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.denied:
        if (context.mounted) {
          await showMessageDialog(
            context: context,
            title: '権限エラー',
            content: 'カメラ撮影が許可されていないので写真を撮影できません。',
          );
        }
        return false;
      case PermissionStatus.permanentlyDenied:
        if (context.mounted) {
          final result = await showConfirmationDialog(
            context: context,
            title: '権限エラー',
            content: 'カメラ撮影が拒否されているため写真を撮影できません。\n設定画面でカメラ撮影を許可しますか？',
            positiveButtonText: 'はい',
            negativeButtonText: 'いいえ',
          );
          if (result) {
            openAppSettings();
          }
        }
        return false;
      default:
        return false;
    }
  }

  static Future<bool> requestStoragePermission(BuildContext context) async {
    final status = Platform.isIOS
        ? await Permission.photos.request()
        : await Permission.storage.request();
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        return true;
      case PermissionStatus.denied:
        if (context.mounted) {
          await showMessageDialog(
            context: context,
            title: '権限エラー',
            content: 'カメラ撮影が許可されていないので写真を撮影できません。',
          );
        }
        return false;
      case PermissionStatus.permanentlyDenied:
        if (context.mounted) {
          final result = await showConfirmationDialog(
            context: context,
            title: '権限エラー',
            content: 'カメラ撮影が拒否されているため写真を撮影できません。\n設定画面でカメラ撮影を許可しますか？',
            positiveButtonText: 'はい',
            negativeButtonText: 'いいえ',
          );
          if (result) {
            openAppSettings();
          }
        }
        return false;
      case PermissionStatus.restricted:
        if (context.mounted) {
          await showMessageDialog(
            context: context,
            title: '権限エラー',
            content: 'カメラ撮影が制限されているので写真を撮影できません。',
          );
        }
        return false;
      default:
        return false;
    }
  }

  static Future<bool> requestNotificationPermission(
    BuildContext context,
  ) async {
    final status = await Permission.notification.request();
    switch (status) {
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.denied:
        if (context.mounted) {
          await showMessageDialog(
            context: context,
            title: '権限エラー',
            content: '現在プッシュ通知が受け取れない設定になっています。\n通知設定画面に遷移できません。',
          );
        }
        return false;
      case PermissionStatus.permanentlyDenied:
        if (context.mounted) {
          final result = await showConfirmationDialog(
            context: context,
            title: '権限エラー',
            content: '現在プッシュ通知が受け取れない設定になっています。\n設定画面で通知を許可しますか？',
            positiveButtonText: 'はい',
            negativeButtonText: 'いいえ',
          );
          if (result) {
            openAppSettings();
          }
        }
        return false;
      default:
        return false;
    }
  }
}
