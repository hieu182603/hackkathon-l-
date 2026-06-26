import 'package:hackathon/features/auth/application/services/i_auth_service.dart';
import 'package:hackathon/features/auth/domain/entities/user.dart';
import 'package:hackathon/features/auth/domain/repositories/i_auth_repository.dart';

class AuthServiceImpl implements IAuthService {
  final IAuthRepository _authRepository;
  AuthServiceImpl(this._authRepository);
  @override
  Future<User> login({
    required String username,
    required String password,
  }) async {
    final normalizedUsername = username.trim();

    if (normalizedUsername.isEmpty) {
      throw ArgumentError('Username khong duoc de trong');
    }
    if (password.isEmpty) {
      throw ArgumentError('Password khong duoc de trong');
    }
    if (password.length < 6) {
      throw ArgumentError('Password phai co it nhat 6 ky tu');
    }
    return _authRepository.login(
      username: normalizedUsername,
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

