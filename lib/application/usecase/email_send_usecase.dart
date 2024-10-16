import 'package:green_heart/application/interface/email_service.dart';

class EmailSendUsecase {
  final EmailService _emailService;

  EmailSendUsecase(this._emailService);

  Future<void> execute() async {
    await _emailService.sendEmail();
  }
}
