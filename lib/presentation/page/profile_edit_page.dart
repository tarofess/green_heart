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
import 'package:green_heart/application/di/shared_pref_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/account_state_notifier.dart';

class ProfileEditPage extends HookConsumerWidget {
  ProfileEditPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _bioFocusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = useState<Profile?>(null);
    final imagePath = useState<String?>(null);
    final nameTextController = useTextEditingController();
    final birthdayTextController = useTextEditingController();
    final bioTextController = useTextEditingController();
    final showBirthday = useState(false);
    final savedBirthday = useState('');

    useEffect(() {
      void initializeForm() async {
        final profileState = await ref.read(profileNotifierProvider.future);
        profile.value = profileState;
        imagePath.value = profileState?.imageUrl;
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
    ValueNotifier<String?> imagePath,
    Profile? profile,
  ) {
    return AppBar(
      title: Text(
        'プロフィール編集',
        style: TextStyle(fontSize: 21.sp),
      ),
      toolbarHeight: 58.h,
      actions: [
        TextButton(
          onPressed: () async {
            try {
              if (_formKey.currentState!.validate()) {
                await LoadingOverlay.of(
                  context,
                  message: '保存中',
                  backgroundColor: Colors.white10,
                ).during(() async {
                  await ref.read(profileNotifierProvider.notifier).saveProfile(
                        ref.read(profileSaveUsecaseProvider),
                        nameTextController.text,
                        birthdayTextController.text,
                        bioTextController.text,
                        imagePath: imagePath.value,
                        oldImageUrl: profile?.imageUrl,
                      );
                  await ref.read(sharedPrefSaveUsecaseProvider).execute(
                        'uid',
                        ref.watch(authStateProvider).value?.uid ?? '',
                      );
                  ref
                      .read(accountStateNotifierProvider.notifier)
                      .setRegisteredState(true);
                });

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
          child: Text(
            '保存',
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildImageField(
      BuildContext context, WidgetRef ref, ValueNotifier<String?> imagePath) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: GestureDetector(
              child: imagePath.value == null
                  ? _buildEmptyImage()
                  : imagePath.value!.startsWith('http')
                      ? _buildFirebaseImage(imagePath.value!)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(100.r),
                          child: Image.file(
                            File(imagePath.value!),
                            width: 200.w,
                            height: 200.h,
                            fit: BoxFit.cover,
                          ),
                        ),
              onTap: () async {
                await showProfileImageActionSheet(context, ref, imagePath);
                _unfocusAllKeyboard();
              },
            ),
          ),
          SizedBox(height: 12.h),
          Center(
            child: TextButton(
              child: Text('プロフィール画像を編集', style: TextStyle(fontSize: 16.sp)),
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
      width: 200.w,
      height: 200.h,
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
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Text(
              'ユーザー名',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(height: 8.r),
          TextFormField(
            style: TextStyle(fontSize: 16.sp),
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
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Text(
                  '生年月日',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
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
                  Text('表示', style: TextStyle(fontSize: 16.sp)),
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
                  Text('非表示', style: TextStyle(fontSize: 16.sp)),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          if (showBirthday.value)
            TextFormField(
              style: TextStyle(fontSize: 16.sp),
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
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Text(
              '自己紹介',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            style: TextStyle(fontSize: 16.sp),
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
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
