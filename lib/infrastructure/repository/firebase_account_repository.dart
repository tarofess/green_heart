import 'package:firebase_auth/firebase_auth.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/account_repository.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class FirebaseAccountRepository implements AccountRepository {
  @override
  Future<void> deleteAccount(User user) async {
    try {
      await user.delete();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('アカウントの削除に失敗しました。再度お試しください。');
    }
  }
}
