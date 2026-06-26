class User {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final String imageUrl;
  final String? password;
  final int? age;
  final String? accessToken;
  final String? refreshToken;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.imageUrl,
    this.password,
    this.age,
    this.accessToken,
    this.refreshToken,
  });
}
