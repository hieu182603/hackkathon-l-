import 'package:hackathon/features/domain/entities/user.dart';
import 'package:hackathon/features/domain/repositories/i_auth_repository.dart';
import 'package:hackathon/core/errors/app_exception.dart';

class AuthRepositoryImpl implements IAuthRepository {
  bool _isLoggedIn = false;

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    // Artificial delay to simulate network call
    await Future.delayed(const Duration(milliseconds: 800));

    if (email == 'admin@gmail.com' && password == '123456') {
      _isLoggedIn = true;
      return const User(
        id: '1',
        username: 'admin',
        email: 'admin@gmail.com',
        fullName: 'Administrator',
        imageUrl: '',
      );
    } else {
      throw AppException('Invalid email or password');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return _isLoggedIn;
  }

  @override
  Future<void> logout() async {
    _isLoggedIn = false;
  }
}
