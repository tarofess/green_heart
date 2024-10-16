import 'package:url_launcher/url_launcher.dart';

import 'package:green_heart/application/interface/email_service.dart';
import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class ContactEmailService implements EmailService {
  @override
  Future<void> sendEmail() async {
    try {
      final String encodedSubject = Uri.encodeComponent('お問い合わせ');
      final String encodedBody = Uri.encodeComponent('ここにお問い合わせ内容を入力してください。');
      final String encodedRecipient =
          Uri.encodeComponent('グリーンハート アプリ <hopchyland@gmail.com>');

      final Uri emailLaunchUri = Uri.parse(
          'mailto:$encodedRecipient?subject=$encodedSubject&body=$encodedBody');

      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        throw AppException('メールアプリを起動できませんでした。');
      }
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('メールを送信できませんでした。再度お試しください。');
    }
  }
}
