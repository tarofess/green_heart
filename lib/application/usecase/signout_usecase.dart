import 'package:green_heart/application/interface/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _authRepository;

  SignOutUseCase(this._authRepository);

  Future<void> execute() async {
    try {
      await _authRepository.signOut();
    } catch (e) {
      throw Exception('サインアウトに失敗しました');
    }
  }
}
