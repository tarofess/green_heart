import 'package:green_heart/application/interface/email_service.dart';

class EmailSendUsecase {
  final EmailService _emailService;

  EmailSendUsecase(this._emailService);

  Future<void> execute() async {
    try {
      await _emailService.sendEmail();
    } catch (e) {
      throw Exception('メールを送信できませんでした。再度お試しください。');
    }
  }
}
