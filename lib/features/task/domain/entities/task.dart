class ChecklistItem {
  final String title;
  bool isCompleted;

  ChecklistItem({
    required this.title,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'isCompleted': isCompleted,
      };

  factory ChecklistItem.fromJson(Map<String, dynamic> json) => ChecklistItem(
        title: json['title'] as String,
        isCompleted: json['isCompleted'] as bool,
      );
}

class Task {
  final int? id;
  final String title;
  final String description;
  final String deadline;
  final int status; // 0 = pending, 1 = completed
  final String subject;
  final String priority; // Cao, Trung bình, Thấp
  final String? groupName;
  final String creator;
  final List<ChecklistItem> checklist;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.deadline,
    this.status = 0,
    required this.subject,
    required this.priority,
    this.groupName,
    required this.creator,
    this.checklist = const [],
  });

  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? deadline,
    int? status,
    String? subject,
    String? priority,
    String? groupName,
    String? creator,
    List<ChecklistItem>? checklist,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      subject: subject ?? this.subject,
      priority: priority ?? this.priority,
      groupName: groupName ?? this.groupName,
      creator: creator ?? this.creator,
      checklist: checklist ?? this.checklist,
    );
  }
}
