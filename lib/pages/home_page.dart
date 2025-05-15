import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight, _deviceWidth;

  // Use Dart's built-in DateTime for the current date
  final String _currentDate =
      "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";

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
          subtitle: Text("Date: $_currentDate"), // Subtitle with current date
          trailing: Icon(
            task["completed"] ? Icons.check_box : Icons.check_box_outline_blank,
            color: task["completed"]
                ? Colors.red
                : Colors.grey, // Checkbox color changed to red for completed
          ),
          onTap: () {
            setState(() {
              // Toggle the completion status of the task
              task["completed"] = !task["completed"];
            });
          },
        );
      },
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: () {
        // Action for adding a new task can go here
      },
      child: const Icon(Icons.add),
      backgroundColor: Colors.red, // Set FloatingActionButton color to red
    );
  }
}