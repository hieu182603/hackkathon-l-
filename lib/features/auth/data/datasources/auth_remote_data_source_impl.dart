import 'package:dio/dio.dart';
import 'package:hackathon/core/constants/api_constants.dart';
import 'package:hackathon/core/errors/app_exception.dart';
import 'package:hackathon/features/auth/data/dtos/login_request_dto.dart';
import 'package:hackathon/features/auth/data/dtos/login_response_dto.dart';

class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  Future<LoginResponseDto> login(LoginRequestDto request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstant.loginEndpoint,
        data: request.toJson(),
      );
      final data = response.data;
      if (data != null) {
        return LoginResponseDto.fromJson(data);
      } else {
        throw const AppException('No data received from login API');
      }
    } on DioException catch (error) {
      throw AppException(_getErrorMessage(error));
    }
  }
}

String _getErrorMessage(DioException error) {
  final data = error.response?.data;
  if (data is Map<String, dynamic>) {
    final message = data['message'];
    if (message != null) {
      return message.toString();
    }
  }
  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.sendTimeout) {
    return 'Connection timed out. Please try again later.';
  }
  if (error.type == DioExceptionType.connectionError) {
    return 'Failed to connect to the server. Please check your internet connection.';
  }

  return 'An unexpected error occurred. Please try again later.';
}

