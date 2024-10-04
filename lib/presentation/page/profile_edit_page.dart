import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:green_heart/application/state/profile_provider.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/presentation/dialog/message_dialog.dart';
import 'package:green_heart/presentation/widget/loading_overlay.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileEditPage extends HookConsumerWidget {
  ProfileEditPage({super.key, required this.user});

  final formKey = GlobalKey<FormState>();
  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameTextController = useTextEditingController();
    final birthYearTextController = useTextEditingController();
    final birthMonthTextController = useTextEditingController();
    final birthDayTextController = useTextEditingController();
    final bioTextController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール編集'),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                if (formKey.currentState!.validate()) {
                  final profile = Profile(
                    uid: user.uid,
                    name: nameTextController.text,
                    birthDate: DateTime(
                      int.parse(birthYearTextController.text),
                      int.parse(birthMonthTextController.text),
                      int.parse(birthDayTextController.text),
                    ),
                    bio: bioTextController.text,
                    imageUrl: '',
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );

                  await LoadingOverlay.of(context).during(
                    () => ref.read(profileSaveProvider(profile)).execute(),
                  );

                  if (context.mounted) {
                    await showMessageDialog(
                      context: context,
                      title: '保存完了',
                      content: 'プロフィールを保存しました。',
                    );
                  }

                  ref.read(profileStateProvider.notifier).state = profile;
                  if (context.mounted) context.go('/home');
                }
              } catch (e) {
                print('Failed to save profile: $e');
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildImageField(),
              buildNameField(nameTextController),
              buildBirthdayField(
                birthYearTextController,
                birthMonthTextController,
                birthDayTextController,
              ),
              buildBioField(bioTextController),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImageField() {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 100.r,
              backgroundColor: Colors.grey[200],
              child: Icon(
                Icons.person,
                size: 100.r,
                color: Colors.grey[500],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('プロフィール画像を編集'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNameField(TextEditingController nameTextController) {
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
          TextField(
            controller: nameTextController,
            decoration: buildInputDecoration('名前'),
          ),
        ],
      ),
    );
  }

  Widget buildBirthdayField(
    TextEditingController birthYearTextController,
    TextEditingController birthMonthTextController,
    TextEditingController birthDayTextController,
  ) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.r),
            child: const Text(
              '生年月日',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8.r),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: TextField(
                  controller: birthYearTextController,
                  keyboardType: TextInputType.number,
                  decoration: buildInputDecoration('西暦'),
                ),
              ),
              SizedBox(width: 8.r),
              Flexible(
                child: TextField(
                  controller: birthMonthTextController,
                  keyboardType: TextInputType.number,
                  decoration: buildInputDecoration('月'),
                ),
              ),
              SizedBox(width: 8.r),
              Flexible(
                child: TextField(
                  controller: birthDayTextController,
                  keyboardType: TextInputType.number,
                  decoration: buildInputDecoration('日'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBioField(TextEditingController bioTextController) {
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
          TextField(
            controller: bioTextController,
            decoration: buildInputDecoration('自己紹介文を入力してください'),
            maxLines: 5,
          ),
        ],
      ),
    );
  }

  InputDecoration buildInputDecoration(String hintText) {
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
}
