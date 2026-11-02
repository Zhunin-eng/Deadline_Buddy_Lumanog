class Task {
  final int? id;
  final String title;
  final String description;
  final String subject;
  final String dueDate;
  final bool isCompleted;
  final String createdAt;
  final String updatedAt;

  const Task({
    this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.dueDate,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? subject,
    String? dueDate,
    bool? isCompleted,
    String? createdAt,
    String? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      subject: subject ?? this.subject,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toMap() => {
        'title': title,
        'description': description,
        'subject': subject,
        'dueDate': dueDate,
        'isCompleted': isCompleted ? 1 : 0,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  factory Task.fromMap(Map<String, Object?> map) => Task(
        id: map['id'] as int?,
        title: map['title'] as String,
        description: map['description'] as String? ?? '',
        subject: map['subject'] as String,
        dueDate: map['dueDate'] as String,
        isCompleted: (map['isCompleted'] as int) == 1,
        createdAt: map['createdAt'] as String,
        updatedAt: map['updatedAt'] as String,
      );
}
