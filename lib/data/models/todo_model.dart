class Todo {
  final int userId;
  final int id;
  final String title;
  final bool completed;
  final bool isFavorite;

  Todo({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
    this.isFavorite = false,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
      isFavorite: json['isFavorite'] ?? false, // local-only
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'completed': completed,
      'isFavorite': isFavorite,
    };
  }

  Todo copyWith({bool? isFavorite}) {
    return Todo(
      userId: userId,
      id: id,
      title: title,
      completed: completed,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
