import 'package:green_heart/application/interface/email_service.dart';
import 'package:green_heart/domain/type/result.dart';

class EmailSendUsecase {
  final EmailService _emailService;

  EmailSendUsecase(this._emailService);

  Future<Result> execute() async {
    try {
      await _emailService.sendEmail();
      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
