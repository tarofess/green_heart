class PostValidater {
  static String? validateContent(String content) {
    if (content.length > 1000) return '投稿は1000文字以内で入力してください';
    return null;
  }
}
