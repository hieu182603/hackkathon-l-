import 'package:flutter/material.dart';
import 'package:hackathon/features/task/domain/entities/task.dart';
import 'package:hackathon/features/task/presentation/viewmodels/task_view_model.dart';
import 'package:provider/provider.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;
  const TaskDetailPage({super.key, required this.task});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  @override
  Widget build(BuildContext context) {
    final taskViewModel = context.watch<TaskViewModel>();
    final theme = Theme.of(context);

    // Fetch the latest version of this task from the ViewModel to ensure real-time UI updates
    final currentTaskIndex = taskViewModel.tasks.indexWhere((t) => t.id == widget.task.id);
    final task = currentTaskIndex != -1 ? taskViewModel.tasks[currentTaskIndex] : widget.task;

    final isCompleted = task.status == 1;

    // Calculate Checklist Progress
    final totalChecklistItems = task.checklist.length;
    final completedChecklistItems = task.checklist.where((item) => item.isCompleted).length;
    final double progressPercentage = totalChecklistItems > 0 ? (completedChecklistItems / totalChecklistItems) : 0.0;

    // Status Badge Styling
    Color statusColor;
    Color statusBg;
    String statusText;

    if (isCompleted) {
      statusText = 'Đã hoàn thành';
      statusColor = const Color(0xFF10B981);
      statusBg = const Color(0xFFECFDF5);
    } else if (task.deadline.contains('23/05/2024')) {
      statusText = 'Hôm nay';
      statusColor = const Color(0xFFF97316);
      statusBg = const Color(0xFFFFF7ED);
    } else {
      statusText = 'Sắp tới';
      statusColor = const Color(0xFF3B82F6);
      statusBg = const Color(0xFFEFF6FF);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chi tiết nhiệm vụ',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Violet Summary Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF), // Soft light-violet/lavender bg
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4F46E5), // Indigo
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildIconDetailRow(Icons.menu_book_outlined, task.subject, const Color(0xFF4F46E5)),
                    const SizedBox(height: 10),
                    _buildIconDetailRow(Icons.calendar_today_outlined, '${task.deadline} (Thứ Bảy)   •   09:00', const Color(0xFF4F46E5)),
                    const SizedBox(height: 10),
                    _buildIconDetailRow(Icons.outlined_flag, 'Ưu tiên: ${task.priority}', const Color(0xFF4F46E5)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 2. Metadata Grid (Status, Group, Creator)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    _buildMetadataRow('Trạng thái', statusText, valueColor: statusColor),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    _buildMetadataRow('Nhóm', task.groupName ?? 'Không có'),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    _buildMetadataRow('Người tạo', task.creator),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. Description Section
              const Text(
                'Mô tả',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Text(
                  task.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 4. Checklist Section
              if (task.checklist.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Checklist',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    Text(
                      '$completedChecklistItems/$totalChecklistItems',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Checklist progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progressPercentage,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                  ),
                ),
                const SizedBox(height: 12),
                // Checklist checkboxes
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: task.checklist.length,
                    itemBuilder: (context, index) {
                      final item = task.checklist[index];
                      return CheckboxListTile(
                        value: item.isCompleted,
                        title: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 14,
                            decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                            color: item.isCompleted ? Colors.black38 : Colors.black87,
                          ),
                        ),
                        activeColor: theme.colorScheme.primary,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        onChanged: (val) {
                          taskViewModel.toggleChecklistItem(task.id!, index);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
              ],

              // 5. Action Buttons (Update / Delete)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E7FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextButton.icon(
                        onPressed: () {
                          // Toggle completion status as an example of update
                          taskViewModel.toggleTaskStatus(task.id!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                task.status == 0
                                    ? 'Đã đánh dấu hoàn thành nhiệm vụ!'
                                    : 'Đã chuyển nhiệm vụ về trạng thái sắp tới!',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit_outlined, color: Color(0xFF4F46E5)),
                        label: const Text(
                          'Cập nhật',
                          style: TextStyle(
                            color: Color(0xFF4F46E5),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextButton.icon(
                        onPressed: () {
                          taskViewModel.deleteTask(task.id!);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Đã xóa nhiệm vụ!')),
                          );
                        },
                        icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                        label: const Text(
                          'Xóa',
                          style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconDetailRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetadataRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
