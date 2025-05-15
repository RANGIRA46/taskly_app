class Task {
  String content;
  DateTime timestamp;
  bool done;

  // Constructor with default value for `done`
  Task({
    required this.content,
    required this.timestamp,
    this.done = false, // Default value set to false
  });

  // Factory constructor to create a Task from a Map
  factory Task.fromMap(Map<String, dynamic> task) {
    return Task(
      content: task["content"],
      timestamp: DateTime.parse(task["timestamp"]), // Parse timestamp to DateTime
      done: task["done"] ?? false, // Default to false if 'done' is missing
    );
  }

  // Convert Task to a Map
  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'timestamp': timestamp.toIso8601String(), // Convert DateTime to ISO8601 string
      'done': done,
    };
  }

  @override
  String toString() {
    return 'Task{content: $content, timestamp: $timestamp, done: $done}';
  }
}