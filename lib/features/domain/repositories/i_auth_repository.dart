import 'package:hackathon/features/domain/entities/user.dart';

abstract interface class IAuthRepository {
  Future<User> login({
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<bool> isLoggedIn();
}
