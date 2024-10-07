class ProfileValidater {
  static String? validateName(String name) {
    if (name.isEmpty) return '名前は必須です';
    if (name.length > 20) return '名前は20文字以内で入力してください';
    return null;
  }

  static String? validateBirthYear(String birthYear) {
    if (birthYear.isEmpty) return '年を入力してください';
    if (birthYear.toString().length != 4) return '正しい年を入力してください';
    return null;
  }

  static String? validateBirthMonth(String birthMonth) {
    if (birthMonth.isEmpty) return '月を入力してください';
    if (int.parse(birthMonth) < 1 || int.parse(birthMonth) > 12) {
      return '正しい月を入力してください';
    }
    return null;
  }

  static String? validateBirthDay(String birthDay) {
    if (birthDay.isEmpty) return '日を入力してください';
    if (int.parse(birthDay) < 1 || int.parse(birthDay) > 31) {
      return '正しい日を入力してください';
    }
    return null;
  }

  static String? validateBio(String bio) {
    if (bio.length > 150) return '自己紹介は150文字以内で入力してください';
    return null;
  }
}
