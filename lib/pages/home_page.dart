import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight, _deviceWidth;

  String? _newTaskContent; // For storing user input from the TextField

  // Example: List of tasks with completion status
  final List<Map<String, dynamic>> _tasks = [
    {"title": "Do Laundry", "completed": true},
    {"title": "Eat Pizza", "completed": true},
    {"title": "Complete Flutter Project", "completed": false},
  ];

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
      body: _taskslist(),
      floatingActionButton: _addTaskButton(),
    );
  }

  Widget _taskslist() {
    return ListView.builder(
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return ListTile(
          title: Text(
            task["title"],
            style: TextStyle(
              decoration: task["completed"]
                  ? TextDecoration.lineThrough
                  : TextDecoration.none, // Strike-through for completed tasks
              fontSize: 18,
            ),
          ),
          trailing: Icon(
            task["completed"] ? Icons.check_box : Icons.check_box_outline_blank,
            color: task["completed"]
                ? Colors.red
                : Colors.grey, // Checkbox color changed to red for completed
          ),
        );
      },
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: _displayTaskPopup, // Display popup but won't add tasks
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
          content: TextField(
            decoration: const InputDecoration(hintText: "Enter task here"),
            onChanged: (_value) {
              setState(() {
                _newTaskContent = _value; // Update input value, but no action taken
              });
            },
          ),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}