import 'package:green_heart/application/interface/email_repository.dart';

class EmailSendUsecase {
  final EmailRepository _emailRepository;

  EmailSendUsecase(this._emailRepository);

  Future<void> execute() async {
    try {
      await _emailRepository.sendEmail();
    } catch (e) {
      throw Exception('メールを送信できませんでした。再度お試しください。');
    }
  }
}
