import 'dart:async';

import 'package:green_heart/application/interface/auth_service.dart';

class SignOutUseCase {
  final AuthService _authService;

  SignOutUseCase(this._authService);

  Future<void> execute() async {
    await _authService.signOut();
  }
}
