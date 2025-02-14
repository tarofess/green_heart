import 'dart:io';
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
import 'package:green_heart/application/state/account_state_notifier.dart';
import 'package:green_heart/presentation/widget/user_empty_image.dart';
import 'package:green_heart/presentation/widget/user_firebase_image.dart';
import 'package:green_heart/application/state/profile_edit_page_state_notifier.dart';
import 'package:green_heart/domain/type/profile_edit_page_state.dart';
import 'package:green_heart/presentation/widget/async_error_widget.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/domain/type/result.dart';

class ProfileEditPage extends HookConsumerWidget {
  ProfileEditPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();
  final _bioFocusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileEditPageStateProvider =
        ref.watch(profileEditPageStateNotifierProvider);
    final imagePath = useState<String?>(null);
    final nameTextController = useTextEditingController();
    final birthdayTextController = useTextEditingController();
    final bioTextController = useTextEditingController();

    useEffect(() {
      imagePath.value =
          profileEditPageStateProvider.valueOrNull?.profile?.imageUrl;
      nameTextController.text =
          profileEditPageStateProvider.valueOrNull?.profile?.name ?? '';
      birthdayTextController.text = DateUtil.convertToJapaneseDate(
        profileEditPageStateProvider.valueOrNull?.profile?.birthday,
      );
      bioTextController.text =
          profileEditPageStateProvider.valueOrNull?.profile?.bio ?? '';
      return null;
    }, [profileEditPageStateProvider.value?.profile]);

    return profileEditPageStateProvider.when(
      data: (profileEditPageState) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: _buildAppBar(
              context,
              ref,
              imagePath,
              nameTextController,
              birthdayTextController,
              bioTextController,
              profileEditPageState,
            ),
            body: SafeArea(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildImageField(context, ref, imagePath),
                      _buildNameField(context, nameTextController),
                      _buildBirthdayField(
                        context,
                        ref,
                        birthdayTextController,
                        profileEditPageState,
                      ),
                      _buildBioField(context, bioTextController),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      loading: () {
        return const LoadingIndicator(message: 'プロフィール取得中');
      },
      error: (error, stackTrace) {
        return AsyncErrorWidget(
          error: error,
          retry: () => ref.refresh(profileEditPageStateNotifierProvider),
        );
      },
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<String?> imagePath,
    TextEditingController nameTextController,
    TextEditingController birthdayTextController,
    TextEditingController bioTextController,
    ProfileEditPageState profileEditPageState,
  ) {
    return AppBar(
      title: const Text('プロフィール編集'),
      actions: [
        TextButton(
          child: const Text(
            '保存',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              return;
            }

            final result = await LoadingOverlay.of(
              context,
              backgroundColor: Colors.white10,
            ).during(() async {
              return ref.read(profileSaveUsecaseProvider).execute(
                    ref.watch(authStateProvider).value?.uid,
                    nameTextController.text,
                    birthdayTextController.text,
                    bioTextController.text,
                    imagePath.value,
                    profileEditPageState.profile?.imageUrl,
                  );
            });

            if (!context.mounted) return;

            switch (result) {
              case Success():
                if (profileEditPageState.profile == null) {
                  // 新規登録時
                  await showMessageDialog(
                    context: context,
                    title: '登録完了',
                    content: 'プロフィールを登録しました。\nアプリをお楽しみください！',
                  );

                  final accountStateNotifier = ref.read(
                    accountStateNotifierProvider.notifier,
                  );
                  accountStateNotifier.setRegisteredState(true);
                } else {
                  // 更新時
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('プロフィールを更新しました。')),
                  );
                  context.pop();
                }
                break;
              case Failure(message: final message):
                showErrorDialog(
                  context: context,
                  title: '保存失敗',
                  content: message,
                );
                break;
            }
          },
        ),
      ],
    );
  }

  Widget _buildImageField(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<String?> imagePath,
  ) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: GestureDetector(
              child: imagePath.value == null
                  ? const UserEmptyImage(radius: 100)
                  : imagePath.value!.startsWith('http')
                      ? UserFirebaseImage(
                          imageUrl: imagePath.value,
                          radius: 200.r,
                        )
                      : _buildSelectedImage(imagePath.value!),
              onTap: () async {
                await showProfileImageActionSheet(context, ref, imagePath);
                _unfocusAllKeyboard();
              },
            ),
          ),
          SizedBox(height: 12.h),
          Center(
            child: TextButton(
              child: const Text(
                'プロフィール画像を編集',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
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

  Widget _buildSelectedImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.r),
      child: Image.file(
        File(imageUrl),
        width: 200.r,
        height: 200.r,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildNameField(
    BuildContext context,
    TextEditingController nameTextController,
  ) {
    const int maxLength = 12;
    final remainingChars = useState(maxLength);

    useEffect(() {
      void listener() {
        remainingChars.value = maxLength - nameTextController.text.length;
      }

      nameTextController.addListener(listener);
      return () => nameTextController.removeListener(listener);
    }, [nameTextController]);

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: const Text('ユーザー名'),
          ),
          SizedBox(height: 8.r),
          TextFormField(
            focusNode: _nameFocusNode,
            controller: nameTextController,
            maxLength: maxLength,
            decoration:
                _buildInputDecoration('名前を入力してください').copyWith(counterText: ''),
            validator: (value) {
              return ProfileValidater.validateName(nameTextController.text);
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '残り${remainingChars.value}文字',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBirthdayField(
    BuildContext context,
    WidgetRef ref,
    TextEditingController birthdayTextController,
    ProfileEditPageState profileEditPageState,
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
                child: const Text('生年月日'),
              ),
              const Spacer(),
              Row(
                children: [
                  _buildShowRadioButton(
                    ref,
                    profileEditPageState,
                    birthdayTextController,
                  ),
                  const Text('表示'),
                  _buildHideRadioButton(
                    ref,
                    profileEditPageState,
                    birthdayTextController,
                  ),
                  const Text('非表示'),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          if (profileEditPageState.isShowBirthday)
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

  Widget _buildShowRadioButton(
    WidgetRef ref,
    ProfileEditPageState profileEditPageState,
    TextEditingController birthdayTextController,
  ) {
    return Radio<bool>(
      value: true,
      groupValue: profileEditPageState.isShowBirthday,
      onChanged: (value) {
        if (value == null) return;

        ref
            .read(profileEditPageStateNotifierProvider.notifier)
            .setIsShowBirthday(value);
        if (value) {
          birthdayTextController.text = profileEditPageState.savedBirthday;
        }
      },
    );
  }

  Widget _buildHideRadioButton(
    WidgetRef ref,
    ProfileEditPageState profileEditPageState,
    TextEditingController birthdayTextController,
  ) {
    return Radio<bool>(
      value: false,
      groupValue: profileEditPageState.isShowBirthday,
      onChanged: (value) {
        if (value == null) return;

        ref
            .read(profileEditPageStateNotifierProvider.notifier)
            .setIsShowBirthday(value);
        if (!value) {
          ref
              .read(profileEditPageStateNotifierProvider.notifier)
              .setSavedBirthday(birthdayTextController.text);
          birthdayTextController.clear();
        }
      },
    );
  }

  Widget _buildBioField(
    BuildContext context,
    TextEditingController bioTextController,
  ) {
    const int maxLength = 200;
    final remainingChars = useState(maxLength);

    useEffect(() {
      void listener() {
        remainingChars.value = maxLength - bioTextController.text.length;
      }

      bioTextController.addListener(listener);
      return () => bioTextController.removeListener(listener);
    }, [bioTextController]);

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: const Text('自己紹介'),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            focusNode: _bioFocusNode,
            controller: bioTextController,
            decoration: _buildInputDecoration('自己紹介文を200文字以内で入力してください')
                .copyWith(counterText: ''),
            maxLines: 5,
            maxLength: maxLength,
            validator: (value) {
              return ProfileValidater.validateBio(bioTextController.text);
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '残り${remainingChars.value}文字',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.green),
            ),
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
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.green),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
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
