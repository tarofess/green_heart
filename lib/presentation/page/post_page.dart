import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:green_heart/infrastructure/util/permission_util.dart';
import 'package:green_heart/presentation/dialog/error_dialog.dart';
import 'package:green_heart/presentation/viewmodel/post_page_viewmodel.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostPage extends HookConsumerWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(postPageViewModel);
    final focusNode = useFocusNode();
    final postTextController = useTextEditingController();
    final selectedImages = useState<List<String?>>([]);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(focusNode);
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('投稿'),
        leading: IconButton(
          icon: const Icon(Icons.cancel_outlined),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () async {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: postTextController,
                    focusNode: focusNode,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16.r),
                    ),
                  ),
                  _buildPickedImageArea(selectedImages),
                ],
              ),
            ),
          ),
          _buildBottomBar(context, ref, viewModel, selectedImages),
        ],
      ),
    );
  }

  Widget _buildPickedImageArea(ValueNotifier<List<String?>> selectedImages) {
    return selectedImages.value.isNotEmpty
        ? Padding(
            padding: EdgeInsets.only(left: 16.r, right: 16.r, bottom: 16.r),
            child: SizedBox(
              height: 240.r,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selectedImages.value.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(6.r),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.file(
                            File(selectedImages.value[index] ?? ''),
                            width: 240.r,
                            height: 240.r,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8.r,
                          right: 8.r,
                          child: GestureDetector(
                            onTap: () {
                              selectedImages.value =
                                  List.from(selectedImages.value)
                                    ..removeAt(index);
                            },
                            child: Container(
                              padding: EdgeInsets.all(4.r),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20.r,
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
    PostPageViewModel viewModel,
    ValueNotifier<List<String?>> selectedImages,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          _buildImageIconButton(context, ref, viewModel, selectedImages),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.green),
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
    PostPageViewModel viewModel,
    ValueNotifier<List<String?>> selectedImages,
  ) {
    return IconButton(
      icon: Icon(
        Icons.image,
        color: selectedImages.value.length < 4 ? Colors.green : Colors.grey,
      ),
      onPressed: selectedImages.value.length < 4
          ? () async {
              try {
                if (await PermissionUtil.requestStoragePermission(context)) {
                  if (context.mounted) FocusScope.of(context).unfocus();
                  await viewModel.pickImages(selectedImages);
                }
              } catch (e) {
                if (context.mounted) {
                  showErrorDialog(
                    context: context,
                    title: '画像取得エラー',
                    content: e.toString(),
                  );
                }
              }
            }
          : null,
    );
  }
}
