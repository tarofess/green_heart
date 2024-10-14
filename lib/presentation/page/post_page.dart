import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class PostPage extends HookConsumerWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode();
    final postTextController = useTextEditingController();
    final selectedImages = useState<List<XFile>>([]);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(focusNode);
      });
      return null;
    }, []);

    Future<void> pickImages() async {
      FocusScope.of(context).unfocus();

      final ImagePicker picker = ImagePicker();
      try {
        final List<XFile> images = await picker.pickMultiImage(limit: 4);
        selectedImages.value = images;
      } catch (e) {
        throw Exception('画像の取得に失敗しました。再度お試しください。');
      }
    }

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
          _buildBottomBar(pickImages),
        ],
      ),
    );
  }

  Widget _buildPickedImageArea(ValueNotifier<List<XFile>> selectedImages) {
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
                            File(selectedImages.value[index].path),
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

  Widget _buildBottomBar(VoidCallback onImagePick) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.image, color: Colors.green),
            onPressed: onImagePick,
          ),
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
}
