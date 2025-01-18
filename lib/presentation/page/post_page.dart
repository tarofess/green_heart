import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:green_heart/infrastructure/util/permission_util.dart';
import 'package:green_heart/presentation/dialog/error_dialog.dart';
import 'package:green_heart/presentation/dialog/confirmation_dialog.dart';
import 'package:green_heart/presentation/widget/loading_overlay.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/domain/type/result.dart';
import 'package:green_heart/application/di/picture_di.dart';

class PostPage extends HookConsumerWidget {
  const PostPage({super.key, required this.selectedDay});

  final DateTime selectedDay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode();
    final postTextController = useTextEditingController();
    final selectedImages = useState<List<String>>([]);
    useListenable(postTextController);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(focusNode);
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${selectedDay.year}年${selectedDay.month}月${selectedDay.day}日',
          style: TextStyle(fontSize: 21.sp),
        ),
        toolbarHeight: 58.h,
        leading: IconButton(
          icon: Icon(Icons.cancel_outlined, size: 24.r),
          onPressed: () async {
            if (postTextController.text.isEmpty &&
                selectedImages.value.isEmpty) {
              context.pop();
            } else {
              final result = await showConfirmationDialog(
                context: context,
                title: '投稿を破棄しますか？',
                content: '入力内容は保存されません。',
                positiveButtonText: '破棄する',
                negativeButtonText: 'キャンセル',
              );
              if (result) {
                if (context.mounted) context.pop();
              }
            }
          },
        ),
        actions: [
          _buildUploadButton(
            context,
            ref,
            postTextController,
            selectedImages,
            focusNode,
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      style: TextStyle(fontSize: 16.sp),
                      controller: postTextController,
                      focusNode: focusNode,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16.w),
                      ),
                    ),
                    _buildPickedImageArea(selectedImages),
                  ],
                ),
              ),
            ),
            _buildBottomBar(context, ref, selectedImages),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton(
    BuildContext context,
    WidgetRef ref,
    TextEditingController postTextController,
    ValueNotifier<List<String>> selectedImages,
    FocusNode focusNode,
  ) {
    return IconButton(
      icon: Icon(Icons.upload, size: 24.r),
      onPressed:
          postTextController.text.isNotEmpty || selectedImages.value.isNotEmpty
              ? () async {
                  focusNode.unfocus();

                  final result = await LoadingOverlay.of(
                    context,
                    backgroundColor: Colors.white10,
                  ).during(
                    () async {
                      final uid = ref.watch(authStateProvider).value?.uid;
                      return await ref.read(postAddUsecaseProvider).execute(
                            uid,
                            postTextController.text,
                            selectedImages.value,
                            selectedDay,
                          );
                    },
                  );

                  if (!context.mounted) return;

                  switch (result) {
                    case Success():
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '投稿が完了しました。',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      );
                      context.pop();
                      break;
                    case Failure(message: final message):
                      showErrorDialog(
                        context: context,
                        title: '投稿エラー',
                        content: message,
                      );
                  }
                }
              : null,
    );
  }

  Widget _buildPickedImageArea(ValueNotifier<List<String>> selectedImages) {
    return selectedImages.value.isNotEmpty
        ? Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
            child: SizedBox(
              height: 240.r,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selectedImages.value.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(6.w),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.file(
                            File(selectedImages.value[index]),
                            width: 240.w,
                            height: 240.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: GestureDetector(
                            onTap: () {
                              selectedImages.value =
                                  List.from(selectedImages.value)
                                    ..removeAt(index);
                            },
                            child: Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 24.r,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        : const SizedBox();
  }

  Widget _buildBottomBar(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<List<String>> selectedImages,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          _buildImageIconButton(context, ref, selectedImages),
          const Spacer(),
          IconButton(
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.green,
              size: 24.r,
            ),
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImageIconButton(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<List<String>> selectedImages,
  ) {
    return IconButton(
      icon: Icon(
        Icons.image,
        color: selectedImages.value.length < 5 ? Colors.green : Colors.grey,
        size: 24.r,
      ),
      onPressed: selectedImages.value.length < 5
          ? () async {
              if (await PermissionUtil.requestStoragePermission(context)) {
                if (context.mounted) {
                  FocusScope.of(context).unfocus();

                  final result = await LoadingOverlay.of(
                    context,
                    backgroundColor: Colors.white10,
                  ).during(
                    () => ref
                        .read(pickPostImagesUsecaseProvider)
                        .execute(selectedImages),
                  );

                  switch (result) {
                    case Success():
                      break;
                    case Failure(message: final message):
                      if (context.mounted) {
                        showErrorDialog(
                          context: context,
                          title: '画像取得エラー',
                          content: message,
                        );
                      }
                      break;
                  }
                }
              }
            }
          : null,
    );
  }
}
