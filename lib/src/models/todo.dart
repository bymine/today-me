class Todo {
  int? id;
  String title;
  bool isComplete;
  String notes;
  int createDate;
  String createTime;
  int color;

  Todo({
    required this.title,
    required this.notes,
    required this.createTime,
    required this.createDate,
    required this.color,
    this.id,
    this.isComplete = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'todo_id': id,
      'todo_title': title,
      'todo_notes': notes,
      'todo_create_date': createDate,
      'todo_create_time': createTime,
      'todo_color': color,
      'todo_is_complete': isComplete ? 1 : 0,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['todo_id'],
      title: json['todo_title'],
      notes: json['todo_notes'],
      color: json['todo_color'],
      createDate: json['todo_create_date'],
      createTime: json['todo_create_time'],
      isComplete: json['todo_is_complete'] == 1 ? true : false,
    );
  }
}
