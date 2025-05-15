import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart'; // For formatting date and time

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight, _deviceWidth;
  late Box<Map> _taskBox; // Hive box for storing tasks
  String? _newTaskContent; // For storing user input from the TextField
  DateTime? _newTaskDateTime; // For storing selected date and time for the task

  // Initial task list
  final List<Map<String, dynamic>> _tasks = [
    {"title": "Do Laundry", "completed": true, "datetime": "2025-05-15 08:00"},
    {"title": "Eat Pizza", "completed": true, "datetime": "2025-05-15 12:30"},
  ];

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    await Hive.initFlutter(); // Initialize Hive
    _taskBox = await Hive.openBox<Map>("tasks"); // Open the Hive box
    setState(() {}); // Refresh the UI once Hive is initialized
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _deviceHeight * 0.15,
        backgroundColor: Colors.red, // Set AppBar color to red
        title: const Text(
          "Taskly!",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: _tasksView(),
      floatingActionButton: _addTaskButton(),
    );
  }

  Widget _tasksView() {
    return ListView.builder(
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return ListTile(
          title: Text(
            task["title"],
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            "Due: ${task["datetime"]}", // Display the due date and time
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  task["completed"] ? Icons.check_box : Icons.check_box_outline_blank,
                  color: task["completed"] ? Colors.red : Colors.grey,
                ),
                onPressed: () => _toggleTaskCompletion(index), // Toggle task completion
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _displayEditTaskPopup(index), // Edit task
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteTask(index), // Delete task
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: _displayTaskPopup,
      child: const Icon(Icons.add),
      backgroundColor: Colors.red, // Set FloatingActionButton color to red
    );
  }

  void _displayTaskPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(hintText: "Enter task here"),
                onChanged: (_value) {
                  _newTaskContent = _value; // Update the task content
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickDateTime, // Open Date and Time Picker
                child: const Text("Select Date & Time"),
              ),
              if (_newTaskDateTime != null)
                Text(
                  "Selected: ${DateFormat('yyyy-MM-dd HH:mm').format(_newTaskDateTime!)}", // Display selected date and time
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Add"),
              onPressed: () {
                if (_newTaskContent != null &&
                    _newTaskContent!.isNotEmpty &&
                    _newTaskDateTime != null) {
                  _addTask(_newTaskContent!, _newTaskDateTime!);
                }
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _displayEditTaskPopup(int index) {
    String updatedTaskContent = _tasks[index]["title"];
    DateTime updatedTaskDateTime =
        DateFormat('yyyy-MM-dd HH:mm').parse(_tasks[index]["datetime"]);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(hintText: "Edit task here"),
                controller: TextEditingController(text: updatedTaskContent),
                onChanged: (value) {
                  updatedTaskContent = value; // Update the task content
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final dateTime = await _pickDateTimeDialog(updatedTaskDateTime);
                  if (dateTime != null) updatedTaskDateTime = dateTime; // Update the selected date and time
                },
                child: const Text("Select Date & Time"),
              ),
              Text(
                "Selected: ${DateFormat('yyyy-MM-dd HH:mm').format(updatedTaskDateTime)}",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Update"),
              onPressed: () {
                _updateTask(index, updatedTaskContent, updatedTaskDateTime);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          _newTaskDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<DateTime?> _pickDateTimeDialog(DateTime initialDateTime) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDateTime),
      );
      if (time != null) {
        return DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      }
    }
    return null;
  }

  void _addTask(String content, DateTime dateTime) {
    final newTask = {
      "title": content,
      "completed": false, // New tasks are marked as not completed by default
      "datetime": DateFormat('yyyy-MM-dd HH:mm').format(dateTime), // Store the selected date and time
    };
    setState(() {
      _tasks.add(newTask); // Add the task to the list
    });
  }

  void _updateTask(int index, String updatedContent, DateTime updatedDateTime) {
    setState(() {
      _tasks[index]["title"] = updatedContent; // Update the task title
      _tasks[index]["datetime"] =
          DateFormat('yyyy-MM-dd HH:mm').format(updatedDateTime); // Update the task date and time
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index); // Remove the task from the list
    });

    // Optional: Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Task deleted")),
    );
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index]["completed"] = !_tasks[index]["completed"]; // Toggle the completion status
    });
  }
}