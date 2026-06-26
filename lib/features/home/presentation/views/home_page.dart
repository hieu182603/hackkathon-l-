import 'package:flutter/material.dart';
import 'package:hackathon/app/routes/app_routes.dart';
import 'package:hackathon/features/task/presentation/viewmodels/task_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskViewModel = context.watch<TaskViewModel>();
    final theme = Theme.of(context);

    // Filter today's tasks for dashboard display (show first 3 tasks)
    final allTasks = taskViewModel.tasks;
    final todayTasks = allTasks.take(3).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0D000000),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/student_illustration.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.person, color: Color(0xFF6366F1));
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Xin chào, Alex! 👋',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Chúc bạn học tập hiệu quả!',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_none, color: Colors.black87),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Statistics Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'Total Tasks',
                      value: '${taskViewModel.totalTasksCount}',
                      iconColor: const Color(0xFF6366F1),
                      icon: Icons.assignment_outlined,
                      bgColor: const Color(0xFFEEF2FF),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Completed',
                      value: '${taskViewModel.completedTasksCount}',
                      iconColor: const Color(0xFF10B981),
                      icon: Icons.check_circle_outline_outlined,
                      bgColor: const Color(0xFFECFDF5),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Pending',
                      value: '${taskViewModel.pendingTasksCount}',
                      iconColor: const Color(0xFFF59E0B),
                      icon: Icons.watch_later_outlined,
                      bgColor: const Color(0xFFFFFBEB),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Quick Actions
              const Text(
                'Hành động nhanh',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQuickActionCard(
                    context,
                    title: 'Thêm nhiệm vụ',
                    icon: Icons.add,
                    iconBgColor: const Color(0xFFEEF2FF),
                    iconColor: const Color(0xFF6366F1),
                    onTap: () => Navigator.pushNamed(context, AppRouter.addTask),
                  ),
                  _buildQuickActionCard(
                    context,
                    title: 'Lịch học',
                    icon: Icons.calendar_month_outlined,
                    iconBgColor: const Color(0xFFEFF6FF),
                    iconColor: const Color(0xFF3B82F6),
                    onTap: () {},
                  ),
                  _buildQuickActionCard(
                    context,
                    title: 'Ôn tập',
                    icon: Icons.menu_book_outlined,
                    iconBgColor: const Color(0xFFFEF2F2),
                    iconColor: const Color(0xFFEF4444),
                    onTap: () {},
                  ),
                  _buildQuickActionCard(
                    context,
                    title: 'Nhóm',
                    icon: Icons.people_outline,
                    iconBgColor: const Color(0xFFECFEFF),
                    iconColor: const Color(0xFF06B6D4),
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Today's Tasks Headers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nhiệm vụ hôm nay',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRouter.tasks),
                    child: Text(
                      'Xem tất cả',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Tasks List (Mocking first 3 tasks)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: todayTasks.length,
                itemBuilder: (context, index) {
                  final task = todayTasks[index];
                  final isCompleted = task.status == 1;

                  // Priority Color Code
                  // Default color for all tasks
                  Color priorityColor = const Color(0xFF10B981);
                  Color priorityBg = const Color(0xFFECFDF5);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          value: isCompleted,
                          activeColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (val) {
                            taskViewModel.toggleTaskStatus(task);
                          },
                        ),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                          color: isCompleted ? Colors.black38 : Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            '${task.description}',
                            style: const TextStyle(fontSize: 12, color: Colors.black45),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined, size: 12, color: Colors.black38),
                              const SizedBox(width: 4),
                              Text(
                                'Hạn chót: ${task.deadline}',
                                style: const TextStyle(fontSize: 12, color: Colors.black38),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: priorityBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isCompleted ? 'Hoàn thành' : 'Đang chờ',
                          style: TextStyle(
                            color: priorityColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        // Removed taskDetail route
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, 0),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color iconColor,
    required IconData icon,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black38,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 76,
        padding: const EdgeInsets.all(8),
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
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, int activeIndex) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, -4),
          )
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: activeIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.black38,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        onTap: (index) {
          if (index == 0) {
            // Already on home
          } else if (index == 1) {
            Navigator.pushNamed(context, AppRouter.tasks);
          } else if (index == 2) {
            Navigator.pushNamed(context, AppRouter.addTask);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Nhiệm vụ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 30),
            label: 'Thêm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Lịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}
