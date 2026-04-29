class TaskModel {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;

  const TaskModel({
    this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
  });

  TaskModel copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'isCompleted': isCompleted ? 1 : 0,
    'createdAt': createdAt.toIso8601String(),
  };

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      isCompleted: (map['isCompleted'] as int? ?? 0) == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TaskModel &&
              id == other.id &&
              title == other.title &&
              description == other.description &&
              isCompleted == other.isCompleted &&
              createdAt == other.createdAt;

  @override
  int get hashCode =>
      Object.hash(id, title, description, isCompleted, createdAt);

  @override
  String toString() =>
      'TaskModel(id: $id, title: $title, isCompleted: $isCompleted, createdAt: $createdAt)';
}