import 'dart:async';

import 'package:green_heart/application/interface/auth_service.dart';
import 'package:green_heart/domain/type/result.dart';

class SignOutUseCase {
  final AuthService _authService;

  SignOutUseCase(this._authService);

  Future<Result> execute() async {
    try {
      await _authService.signOut();
      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
