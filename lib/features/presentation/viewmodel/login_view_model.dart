import 'package:flutter/foundation.dart';
import 'package:hackathon/core/errors/app_exception.dart';
import 'package:hackathon/features/application/services/interfaces/i_auth_service.dart';
import 'package:hackathon/features/domain/entities/user.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginViewModel extends ChangeNotifier {
  final IAuthService _authService;
  LoginViewModel(this._authService);

  LoginStatus _status = LoginStatus.initial;
  String? _errorMessage;
  User? _currentUser;

  LoginStatus get status => _status;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;

  bool get isLoading => _status == LoginStatus.loading;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _status = LoginStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentUser = await _authService.login(
        email: email,
        password: password,
      );
      _status = LoginStatus.success;
      notifyListeners();
      return true;
    } on AppException catch (error) {
      _status = LoginStatus.failure;
      _errorMessage = error.message;
      notifyListeners();
      return false;
    } catch (error) {
      debugPrint('Login error: $error');
      _status = LoginStatus.failure;
      _errorMessage = 'Đã xảy ra lỗi không xác định';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    _status = LoginStatus.initial;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
