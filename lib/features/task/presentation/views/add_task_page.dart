import 'package:flutter/material.dart';
import 'package:hackathon/features/task/domain/entities/task.dart';
import 'package:hackathon/features/task/presentation/viewmodels/task_view_model.dart';
import 'package:provider/provider.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedSubject = 'Cơ sở dữ liệu';
  String _selectedStatus = 'Sắp tới';
  String _selectedPriority = 'Trung bình'; // Thấp, Trung bình, Cao
  String _selectedGroup = 'Chọn nhóm học tập';
  DateTime _selectedDate = DateTime(2024, 5, 23);

  final List<String> _subjects = [
    'Cơ sở dữ liệu',
    'Lập trình di động',
    'Marketing',
    'Quản trị dự án',
    'Toán học',
    'Trí tuệ nhân tạo'
  ];

  final List<String> _statuses = ['Sắp tới', 'Đã hoàn thành'];
  final List<String> _groups = ['Chọn nhóm học tập', 'Nhóm 1', 'Nhóm 2', 'Nhóm 3', 'Nhóm 4'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final taskViewModel = context.read<TaskViewModel>();

      // Format Date like 'dd/MM/yyyy'
      final day = _selectedDate.day.toString().padLeft(2, '0');
      final month = _selectedDate.month.toString().padLeft(2, '0');
      final year = _selectedDate.year.toString();
      final formattedDate = '$day/$month/$year';

      final task = Task(
        title: _titleController.text,
        subject: _selectedSubject,
        deadline: formattedDate,
        description: _descriptionController.text,
        status: _selectedStatus == 'Đã hoàn thành' ? 1 : 0,
        priority: _selectedPriority,
        groupName: _selectedGroup == 'Chọn nhóm học tập' ? null : _selectedGroup,
        creator: 'Alex Nguyen',
        checklist: [
          ChecklistItem(title: 'Nhiệm vụ 1', isCompleted: false),
          ChecklistItem(title: 'Nhiệm vụ 2', isCompleted: false),
        ],
      );

      taskViewModel.addTask(task);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu nhiệm vụ thành công!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Color definitions for Priority Segmented Control
    const lowColor = Color(0xFF10B981);
    const medColor = Color(0xFFF59E0B);
    const highColor = Color(0xFFEF4444);

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
          'Thêm nhiệm vụ',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Field
                const Text(
                  'Tiêu đề',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Nhập tiêu đề nhiệm vụ',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập tiêu đề';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Subject Dropdown
                const Text(
                  'Môn học',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedSubject,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black45),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.book_outlined, color: Colors.black45),
                      prefixIconConstraints: BoxConstraints(minWidth: 32, minHeight: 24),
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedSubject = newValue;
                        });
                      }
                    },
                    items: _subjects.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Deadline Picker
                const Text(
                  'Hạn nộp',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, color: Colors.black45, size: 20),
                            const SizedBox(width: 12),
                            Text(
                              '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                              style: const TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                          ],
                        ),
                        const Icon(Icons.keyboard_arrow_down, color: Colors.black45),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Description Field
                const Text(
                  'Mô tả',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Nhập mô tả chi tiết...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập mô tả';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Status Dropdown
                const Text(
                  'Trạng thái',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black45),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.watch_later_outlined, color: Colors.black45),
                      prefixIconConstraints: BoxConstraints(minWidth: 32, minHeight: 24),
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedStatus = newValue;
                        });
                      }
                    },
                    items: _statuses.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Priority Selector
                const Text(
                  'Ưu tiên',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: ['Thấp', 'Trung bình', 'Cao'].map((priority) {
                    final isSelected = _selectedPriority == priority;
                    Color borderCol;
                    Color textCol;
                    Color fillCol;

                    if (priority == 'Thấp') {
                      borderCol = lowColor;
                      textCol = isSelected ? Colors.white : lowColor;
                      fillCol = isSelected ? lowColor : Colors.white;
                    } else if (priority == 'Trung bình') {
                      borderCol = medColor;
                      textCol = isSelected ? Colors.white : medColor;
                      fillCol = isSelected ? medColor : Colors.white;
                    } else {
                      borderCol = highColor;
                      textCol = isSelected ? Colors.white : highColor;
                      fillCol = isSelected ? highColor : Colors.white;
                    }

                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPriority = priority;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 48,
                          decoration: BoxDecoration(
                            color: fillCol,
                            border: Border.all(color: borderCol, width: 1.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            priority,
                            style: TextStyle(
                              color: textCol,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Group Dropdown (Optional)
                const Text(
                  'Nhóm (tùy chọn)',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedGroup,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black45),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.people_outline, color: Colors.black45),
                      prefixIconConstraints: BoxConstraints(minWidth: 32, minHeight: 24),
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedGroup = newValue;
                        });
                      }
                    },
                    items: _groups.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 32),

                // Action Buttons (Cancel / Save)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Hủy',
                            style: TextStyle(
                              color: Colors.black87,
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
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.secondary,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: TextButton(
                          onPressed: _saveTask,
                          child: const Text(
                            'Lưu nhiệm vụ',
                            style: TextStyle(
                              color: Colors.white,
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
      ),
    );
  }
}
