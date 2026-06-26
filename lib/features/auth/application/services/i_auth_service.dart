import 'package:hackathon/features/auth/domain/entities/user.dart';

abstract interface class IAuthService {
  Future<User> login({required String username, required String password});

  Future<bool> isLoggedIn();

  Future<void> logout();
}

