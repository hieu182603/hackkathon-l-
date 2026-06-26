class UserDto {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String imageUrl;
  const UserDto({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.imageUrl,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as int,
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      imageUrl: json['image'] as String? ?? '',
    );
  }
}

