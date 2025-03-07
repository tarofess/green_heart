import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/picture_di.dart';
import 'package:green_heart/infrastructure/util/permission_util.dart';
import 'package:green_heart/domain/type/result.dart';

Future<void> showProfileImageActionSheet(
  BuildContext context,
  WidgetRef ref,
  ValueNotifier<String?> imagePath,
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
        padding: EdgeInsets.all(16.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, size: 24.r),
              title: Text(
                '写真を撮る',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () async {
                if (await PermissionUtil.requestCameraPermission(context)) {
                  final result =
                      await ref.read(takePhotoUsecaseProvider).execute();

                  switch (result) {
                    case Success(value: final path):
                      if (path == null) return;
                      imagePath.value = path;
                      break;
                    case Failure(message: final message):
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message)),
                        );
                      }
                      break;
                  }
                }
                if (context.mounted) Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, size: 24.r),
              title: Text(
                'カメラフォルダから選択する',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () async {
                if (await PermissionUtil.requestStoragePermission(context)) {
                  final result =
                      await ref.read(pickImageUsecaseProvider).execute();

                  switch (result) {
                    case Success(value: final path):
                      if (path == null) return;
                      imagePath.value = path;
                      break;
                    case Failure(message: final message):
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message)),
                        );
                      }
                      break;
                  }
                }
                if (context.mounted) Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel, size: 24.r),
              title: Text(
                '画像を削除する',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {
                imagePath.value = null;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
