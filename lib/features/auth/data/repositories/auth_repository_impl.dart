import 'package:hackathon/features/auth/data/datasources/auth_local_data_source_impl.dart';
import 'package:hackathon/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:hackathon/features/auth/data/dtos/login_request_dto.dart';
import 'package:hackathon/features/auth/data/mappers/user_mapper.dart';
import 'package:hackathon/features/auth/domain/entities/user.dart';
import 'package:hackathon/features/auth/domain/repositories/i_auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthLocalDataSource _localDataSource;
  final AuthRemoteDataSource _remoteDataSource;
  final UserMapper _userMapper;
  AuthRepositoryImpl({
    required AuthLocalDataSource localDataSource,
    required AuthRemoteDataSource remoteDataSource,
    required UserMapper userMapper,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource,
       _userMapper = userMapper;
  @override
  Future<User> login({
    required String username,
    required String password,
  }) async {
    final request = LoginRequestDto(username: username, password: password);
    final response = await _remoteDataSource.login(request);
    await _localDataSource.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );

    return _userMapper.map(response);
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _localDataSource.hasToken();
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearSession();
  }
}

