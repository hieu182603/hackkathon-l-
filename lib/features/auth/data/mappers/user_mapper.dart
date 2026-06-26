import 'package:hackathon/features/auth/data/dtos/login_response_dto.dart';
import 'package:hackathon/features/auth/data/mappers/i_mapper.dart';
import 'package:hackathon/features/auth/domain/entities/user.dart';

class UserMapper implements IMapper<LoginResponseDto, User> {
  @override
  User map(LoginResponseDto source) {
    return User(
      id: source.user.id,
      username: source.user.username,
      email: source.user.email,
      fullName: '${source.user.firstName} ${source.user.lastName}'.trim(),
      imageUrl: source.user.imageUrl,
      accessToken: source.accessToken,
      refreshToken: source.refreshToken,
    );
  }
}

