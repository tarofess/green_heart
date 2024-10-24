import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:green_heart/domain/feature/profile_validater.dart';
import 'package:green_heart/presentation/dialog/error_dialog.dart';
import 'package:green_heart/presentation/dialog/message_dialog.dart';
import 'package:green_heart/presentation/widget/loading_overlay.dart';
import 'package:green_heart/presentation/widget/profile_image_action_sheet.dart';
import 'package:green_heart/domain/util/date_util.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/domain/type/profile.dart';

class ProfileEditPage extends HookConsumerWidget {
  ProfileEditPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _bioFocusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = useState<Profile?>(null);
    final imagePath = useState('');
    final nameTextController = useTextEditingController();
    final birthdayTextController = useTextEditingController();
    final bioTextController = useTextEditingController();
    final showBirthday = useState(false);
    final savedBirthday = useState('');

    useEffect(() {
      void initializeForm() async {
        final profileState = await ref.read(profileNotifierProvider.future);
        profile.value = profileState;
        imagePath.value = profileState?.imageUrl ?? '';
        nameTextController.text = profileState?.name ?? '';
        birthdayTextController.text =
            DateUtil.convertToJapaneseDate(profileState?.birthday);
        bioTextController.text = profileState?.bio ?? '';
        showBirthday.value = profileState?.birthday == null ? false : true;
        savedBirthday.value = birthdayTextController.text;
      }

      initializeForm();
      return null;
    }, []);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: _buildAppBar(
          context,
          ref,
          nameTextController,
          birthdayTextController,
          bioTextController,
          imagePath,
          profile.value,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildImageField(context, ref, imagePath),
                _buildNameField(nameTextController),
                _buildBirthdayField(
                  context,
                  birthdayTextController,
                  profile.value?.birthday,
                  showBirthday,
                  savedBirthday,
                ),
                _buildBioField(bioTextController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    TextEditingController nameTextController,
    TextEditingController birthdayTextController,
    TextEditingController bioTextController,
    ValueNotifier<String> imagePath,
    Profile? profile,
  ) {
    return AppBar(
      title: const Text('プロフィール編集'),
      actions: [
        TextButton(
          onPressed: () async {
            try {
              if (_formKey.currentState!.validate()) {
                await LoadingOverlay.of(context).during(
                  () async =>
                      ref.read(profileNotifierProvider.notifier).saveProfile(
                            ref.read(profileSaveUsecaseProvider),
                            nameTextController.text,
                            birthdayTextController.text,
                            bioTextController.text,
                            imagePath: imagePath.value,
                            oldImageUrl: profile?.imageUrl,
                          ),
                );

                if (context.mounted) {
                  await showMessageDialog(
                    context: context,
                    title: '保存完了',
                    content: 'プロフィールを保存しました。',
                  );
                }

                if (context.mounted) {
                  profile == null ? context.go('/') : context.pop();
                }
              }
            } catch (e) {
              if (context.mounted) {
                showErrorDialog(
                  context: context,
                  title: '保存失敗',
                  content: e.toString(),
                );
              }
            }
          },
          child: const Text('保存'),
        ),
      ],
    );
  }

  Widget _buildImageField(
      BuildContext context, WidgetRef ref, ValueNotifier<String> imagePath) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: GestureDetector(
              child: imagePath.value == ''
                  ? _buildEmptyImage()
                  : imagePath.value.startsWith('http')
                      ? _buildFirebaseImage(imagePath.value)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(100.r),
                          child: Image.file(
                            File(imagePath.value),
                            width: 200.r,
                            height: 200.r,
                            fit: BoxFit.cover,
                          ),
                        ),
              onTap: () async {
                await showProfileImageActionSheet(context, ref, imagePath);
                _unfocusAllKeyboard();
              },
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              child: const Text('プロフィール画像を編集'),
              onPressed: () async {
                await showProfileImageActionSheet(context, ref, imagePath);
                _unfocusAllKeyboard();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyImage() {
    return CircleAvatar(
      radius: 100.r,
      backgroundColor: Colors.grey[200],
      child: Icon(
        Icons.person,
        size: 100.r,
        color: Colors.grey[500],
      ),
    );
  }

  Widget _buildFirebaseImage(String imageUrl) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(imageUrl),
        ),
      ),
      child: CachedNetworkImage(
        key: ValueKey(imageUrl),
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  Widget _buildNameField(TextEditingController nameTextController) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.r),
            child: const Text(
              'ユーザー名',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8.r),
          TextFormField(
            focusNode: _nameFocusNode,
            controller: nameTextController,
            decoration: _buildInputDecoration('名前を入力してください'),
            validator: (value) {
              return ProfileValidater.validateName(nameTextController.text);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBirthdayField(
    BuildContext context,
    TextEditingController birthdayTextController,
    DateTime? birthday,
    ValueNotifier<bool> showBirthday,
    ValueNotifier<String> savedBirthday,
  ) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.r),
                child: const Text(
                  '生年月日',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: showBirthday.value,
                    onChanged: (value) {
                      showBirthday.value = value!;
                      if (value) {
                        birthdayTextController.text = savedBirthday.value;
                      }
                    },
                  ),
                  const Text('表示'),
                  Radio<bool>(
                    value: false,
                    groupValue: showBirthday.value,
                    onChanged: (value) {
                      showBirthday.value = value!;
                      if (!value) {
                        savedBirthday.value = birthdayTextController.text;
                        birthdayTextController.clear();
                      }
                    },
                  ),
                  const Text('非表示'),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.r),
          if (showBirthday.value)
            TextFormField(
              controller: birthdayTextController,
              decoration: _buildInputDecoration('生年月日を選択してください'),
              readOnly: true,
              onTap: () async {
                await _selectBirthday(context, birthdayTextController);
              },
            )
        ],
      ),
    );
  }

  Widget _buildBioField(TextEditingController bioTextController) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.r),
            child: const Text(
              '自己紹介',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8.r),
          TextFormField(
            focusNode: _bioFocusNode,
            controller: bioTextController,
            decoration: _buildInputDecoration('自己紹介文を200文字以内で入力してください'),
            maxLines: 5,
            validator: (value) {
              return ProfileValidater.validateBio(bioTextController.text);
            },
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: Colors.grey[500]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: Colors.green),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
    );
  }

  Future<void> _selectBirthday(
    BuildContext context,
    TextEditingController birthdayTextController,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('ja', 'JP'),
    );

    if (pickedDate != null) {
      birthdayTextController.text =
          DateFormat('yyyy年MM月dd日').format(pickedDate);
    }
  }

  void _unfocusAllKeyboard() {
    _nameFocusNode.unfocus();
    _bioFocusNode.unfocus();
  }
}
