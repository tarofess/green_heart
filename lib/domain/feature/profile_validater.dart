class ProfileValidater {
  static String? validateName(String name) {
    if (name.isEmpty) return '名前は必須です';
    if (name.length >= 15) return '名前は15文字以内で入力してください';
    return null;
  }

  static String? validateBirthday(String birthday) {
    if (birthday.isEmpty) return '生年月日は必須です';
    return null;
  }

  static String? validateBio(String bio) {
    if (bio.length >= 200) return '自己紹介は200文字以内で入力してください';
    return null;
  }
}
