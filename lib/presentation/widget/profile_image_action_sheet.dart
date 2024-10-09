import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/picture_provider.dart';
import 'package:green_heart/infrastructure/util/permission_util.dart';

Future<void> showProfileImageActionSheet(
  BuildContext context,
  WidgetRef ref,
  ValueNotifier<String> imagePath,
) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, size: 24.r),
              title: Text('写真を撮る', style: TextStyle(fontSize: 14.sp)),
              onTap: () async {
                if (await PermissionUtil.requestCameraPermission(context)) {
                  imagePath.value =
                      await ref.read(takePhotoUsecaseProvider).execute() ?? '';
                }
                if (context.mounted) Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, size: 24.r),
              title: Text('カメラフォルダから選択する', style: TextStyle(fontSize: 14.sp)),
              onTap: () async {
                if (await PermissionUtil.requestStoragePermission(context)) {
                  imagePath.value =
                      await ref.read(pickImageUsecaseProvider).execute() ?? '';
                }
                if (context.mounted) Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel, size: 24.r),
              title: Text('画像を削除する', style: TextStyle(fontSize: 14.sp)),
              onTap: () {
                imagePath.value = '';
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
