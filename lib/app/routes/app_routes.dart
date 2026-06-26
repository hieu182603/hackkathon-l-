import 'package:flutter/material.dart';
import 'package:hackathon/features/auth/presentation/views/login_page.dart';
import 'package:hackathon/features/home/presentation/views/home_page.dart';
import 'package:hackathon/features/task/presentation/views/task_list_page.dart';
import 'package:hackathon/features/task/presentation/views/task_detail_page.dart';
import 'package:hackathon/features/task/presentation/views/add_task_page.dart';
import 'package:hackathon/features/task/domain/entities/task.dart';

class AppRouter {
  AppRouter._();
  static const String login = '/';
  static const String home = '/home';
  static const String tasks = '/tasks';
  static const String addTask = '/add-task';
  static const String taskDetail = '/task-detail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case tasks:
        return MaterialPageRoute(builder: (_) => const TaskListPage());
      case addTask:
        return MaterialPageRoute(builder: (_) => const AddTaskPage());
      case taskDetail:
        final task = settings.arguments as Task;
        return MaterialPageRoute(builder: (_) => TaskDetailPage(task: task));
      default:
        return MaterialPageRoute(builder: (_) => const LoginPage());
    }
  }
}

