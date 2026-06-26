class TaskModel {
  final int? id;
  final String title;
  final String description;
  final String deadline;
  final int status; // 0 for pending, 1 for completed

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.deadline,
    this.status = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline,
      'status': status,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      deadline: map['deadline'],
      status: map['status'],
    );
  }
}
