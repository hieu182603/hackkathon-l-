import 'package:hackathon/features/application/services/interfaces/i_auth_service.dart';
import 'package:hackathon/features/domain/entities/user.dart';
import 'package:hackathon/features/domain/repositories/i_auth_repository.dart';
import 'package:hackathon/core/errors/app_exception.dart';

class AuthServiceImpl implements IAuthService {
  final IAuthRepository _authRepository;

  AuthServiceImpl(this._authRepository);

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim();

    if (normalizedEmail.isEmpty) {
      throw AppException('Email không được để trống');
    }
    if (!normalizedEmail.contains('@')) {
      throw AppException('Email không hợp lệ');
    }
    if (password.isEmpty) {
      throw AppException('Password không được để trống');
    }
    if (password.length < 6) {
      throw AppException('Password phải có ít nhất 6 ký tự');
    }

    return _authRepository.login(
      email: normalizedEmail,
      password: password,
    );
  }

  @override
  Future<bool> isLoggedIn() async {
    return _authRepository.isLoggedIn();
  }

  @override
  Future<void> logout() async {
    await _authRepository.logout();
  }
}
