import 'package:flutter/foundation.dart';
import '../../domain/entities/task.dart';

class TaskViewModel extends ChangeNotifier {
  final List<Task> _tasks = [];
  String _searchQuery = '';
  String _selectedTab = 'Tất cả';

  List<Task> get tasks => List.unmodifiable(_tasks);
  String get searchQuery => _searchQuery;
  String get selectedTab => _selectedTab;

  TaskViewModel() {
    _initializeMockTasks();
  }

  void _initializeMockTasks() {
    _tasks.addAll([
      Task(
        id: 1,
        title: 'Ôn thi CSDL',
        subject: 'Cơ sở dữ liệu',
        deadline: '25/05/2024',
        description: 'Ôn tập các kiến thức quan trọng về mô hình ERD, SQL, chuẩn hóa dữ liệu và các dạng bài tập thường gặp trong đề thi.',
        status: 0, // Sắp tới
        priority: 'Cao',
        groupName: 'Nhóm 3',
        creator: 'Alex Nguyen',
        checklist: [
          ChecklistItem(title: 'Ôn lý thuyết', isCompleted: true),
          ChecklistItem(title: 'Làm bài tập SQL', isCompleted: true),
          ChecklistItem(title: 'Ôn ERD', isCompleted: false),
          ChecklistItem(title: 'Luyện đề thi năm trước', isCompleted: false),
          ChecklistItem(title: 'Review slide bài giảng', isCompleted: false),
        ],
      ),
      Task(
        id: 2,
        title: 'Bài tập Flutter',
        subject: 'Lập trình di động',
        deadline: '23/05/2024',
        description: 'Hoàn thành bài tập ứng dụng di động Flutter và chuẩn bị mã nguồn nộp bài.',
        status: 0, // Sắp tới
        priority: 'Cao',
        groupName: 'Nhóm 2',
        creator: 'Alex Nguyen',
        checklist: [
          ChecklistItem(title: 'Thiết kế giao diện', isCompleted: false),
          ChecklistItem(title: 'Cài đặt SQLite', isCompleted: false),
        ],
      ),
      Task(
        id: 3,
        title: 'Tiểu luận Marketing',
        subject: 'Marketing',
        deadline: '28/05/2024',
        description: 'Viết tiểu luận phân tích chiến dịch Marketing của một thương hiệu lớn.',
        status: 0, // Sắp tới
        priority: 'Trung bình',
        groupName: 'Nhóm 4',
        creator: 'Alex Nguyen',
        checklist: [
          ChecklistItem(title: 'Tìm tài liệu tham khảo', isCompleted: true),
          ChecklistItem(title: 'Viết mở đầu', isCompleted: false),
        ],
      ),
      Task(
        id: 4,
        title: 'Thuyết trình nhóm',
        subject: 'Quản trị dự án',
        deadline: '24/05/2024',
        description: 'Chuẩn bị nội dung và slide báo cáo tiến độ dự án học phần.',
        status: 0, // Sắp tới
        priority: 'Cao',
        groupName: 'Nhóm 3',
        creator: 'Alex Nguyen',
        checklist: [
          ChecklistItem(title: 'Làm slide', isCompleted: true),
          ChecklistItem(title: 'Phân công thuyết trình', isCompleted: false),
        ],
      ),
      Task(
        id: 5,
        title: 'Ôn tập Giải tích',
        subject: 'Toán học',
        deadline: '20/05/2024',
        description: 'Ôn tập lại lý thuyết giới hạn, đạo hàm và tích phân chuẩn bị kiểm tra.',
        status: 1, // Đã hoàn thành
        priority: 'Trung bình',
        groupName: '',
        creator: 'Alex Nguyen',
        checklist: [
          ChecklistItem(title: 'Xem lại bài tập chương 1', isCompleted: true),
          ChecklistItem(title: 'Làm bài tập chương 2', isCompleted: true),
        ],
      ),
      Task(
        id: 6,
        title: 'Đọc tài liệu AI',
        subject: 'Trí tuệ nhân tạo',
        deadline: '21/05/2024',
        description: 'Đọc các chương cơ bản về học máy và mạng nơ-ron nhân tạo.',
        status: 1, // Đã hoàn thành
        priority: 'Thấp',
        groupName: '',
        creator: 'Alex Nguyen',
        checklist: [
          ChecklistItem(title: 'Đọc chương 1-3 sách AI', isCompleted: true),
        ],
      ),
    ]);
  }

  // Getters for Stats
  int get totalTasksCount => _tasks.length;
  int get completedTasksCount => _tasks.where((t) => t.status == 1).length;
  int get pendingTasksCount => _tasks.where((t) => t.status == 0).length;

  // Search & Filter
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedTab(String tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  List<Task> getFilteredTasks() {
    List<Task> result = _tasks;

    // Search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result
          .where((task) =>
              task.title.toLowerCase().contains(query) ||
              task.subject.toLowerCase().contains(query) ||
              task.description.toLowerCase().contains(query))
          .toList();
    }

    // Tab filter
    if (_selectedTab == 'Hôm nay') {
      // For simplicity in UI mock, match hardcoded date or tasks scheduled for "23/05/2024" (mock today)
      result = result.where((task) => task.deadline.contains('23/05/2024')).toList();
    } else if (_selectedTab == 'Sắp tới') {
      result = result.where((task) => task.status == 0).toList();
    } else if (_selectedTab == 'Hoàn thành') {
      result = result.where((task) => task.status == 1).toList();
    }

    return result;
  }

  // Task Operations
  void addTask(Task task) {
    final newId = _tasks.isEmpty ? 1 : (_tasks.map((t) => t.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
    final newTask = task.copyWith(id: newId);
    _tasks.add(newTask);
    notifyListeners();
  }

  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  void deleteTask(int id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void toggleTaskStatus(int id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _tasks[index];
      final newStatus = task.status == 0 ? 1 : 0;
      _tasks[index] = task.copyWith(status: newStatus);
      notifyListeners();
    }
  }

  void toggleChecklistItem(int taskId, int itemIndex) {
    final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex != -1) {
      final task = _tasks[taskIndex];
      final newChecklist = List<ChecklistItem>.from(task.checklist);
      final item = newChecklist[itemIndex];
      newChecklist[itemIndex] = ChecklistItem(
        title: item.title,
        isCompleted: !item.isCompleted,
      );
      _tasks[taskIndex] = task.copyWith(checklist: newChecklist);
      notifyListeners();
    }
  }
}
