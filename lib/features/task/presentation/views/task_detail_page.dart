import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hackathon/features/task/domain/entities/task.dart';
import 'package:hackathon/features/task/presentation/viewmodels/task_view_model.dart';

class TaskDetailPage extends StatelessWidget {
  final Task task;
  const TaskDetailPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TaskViewModel>();
    final currentTaskIndex = viewModel.tasks.indexWhere((t) => t.id == task.id);
    final currentTask = currentTaskIndex != -1 ? viewModel.tasks[currentTaskIndex] : task;
    final isCompleted = currentTask.status == 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              if (currentTask.id != null) {
                viewModel.deleteTask(currentTask.id!);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Task deleted')),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentTask.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.description, 'Description', currentTask.description),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.calendar_today, 'Deadline', currentTask.deadline),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.check_circle,
              'Status',
              isCompleted ? 'Completed' : 'Pending',
              valueColor: isCompleted ? Colors.green : Colors.orange,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  viewModel.toggleTaskStatus(currentTask);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isCompleted ? 'Marked as Pending' : 'Marked as Completed'),
                    ),
                  );
                },
                icon: Icon(isCompleted ? Icons.undo : Icons.check),
                label: Text(isCompleted ? 'Mark Pending' : 'Mark Completed'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCompleted ? Colors.orange : Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(fontSize: 16, color: valueColor ?? Colors.black87),
            ),
          ],
        ),
      ],
    );
  }
}
