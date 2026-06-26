import 'package:flutter/material.dart';
import 'package:hackathon/features/auth/presentation/views/login_page.dart';

// Assuming you have a home page
// import 'package:hackathon/features/home/presentation/views/home_page.dart';

class AppRouter {
  AppRouter._();
  static const String home = '/home';
  static const String login = '/';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case home:
        // return MaterialPageRoute(builder: (_) => const HomePage());
        return MaterialPageRoute(builder: (_) => Scaffold(appBar: AppBar(title: const Text('Home')), body: const Center(child: Text('Home Page'))));
      default:
        return MaterialPageRoute(builder: (_) => const LoginPage());
    }
  }
}
