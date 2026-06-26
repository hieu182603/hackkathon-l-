import 'package:flutter/material.dart';
import 'package:hackathon/features/task/domain/entities/task.dart';

class TaskDetailPage extends StatelessWidget {
  final Task task;
  const TaskDetailPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Center(child: Text(task.description)),
    );
  }
}
