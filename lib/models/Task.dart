class Task {
  final String title;
  final String time;
  final bool isLate;
  bool isDone;

  Task({
    required this.title,
    required this.time,
    required this.isLate,
    required this.isDone,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'] as String,
      time: map['time'] as String,
      isLate: map['isLate'] as bool,
      isDone: map['isDone'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'time': time,
      'isLate': isLate,
      'isDone': isDone,
    };
  }
}
