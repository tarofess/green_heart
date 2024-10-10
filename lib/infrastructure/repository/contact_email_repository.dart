import 'package:url_launcher/url_launcher.dart';

import 'package:green_heart/application/interface/email_repository.dart';

class ContactEmailRepository implements EmailRepository {
  @override
  Future<void> sendEmail() async {
    final String encodedSubject = Uri.encodeComponent('お問い合わせ');
    final String encodedBody = Uri.encodeComponent('ここにお問い合わせ内容を入力してください。');
    final String encodedRecipient =
        Uri.encodeComponent('グリーンハート アプリ <hopchyland@gmail.com>');

    final Uri emailLaunchUri = Uri.parse(
        'mailto:$encodedRecipient?subject=$encodedSubject&body=$encodedBody');

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw Exception('メールを送信できませんでした。再度お試しください。');
    }
  }
}
