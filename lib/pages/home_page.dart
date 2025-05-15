import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight, _deviceWidth;
  late Box<Map> _taskBox; // Hive box for storing tasks
  String? _newTaskContent; // For storing user input from the TextField

  // Initial task list
  final List<Map<String, dynamic>> _tasks = [
    {"title": "Do Laundry", "completed": true},
    {"title": "Eat Pizza", "completed": true},
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
            style: TextStyle(
              decoration: task["completed"]
                  ? TextDecoration.lineThrough
                  : TextDecoration.none, // Strike-through for completed tasks
              fontSize: 18,
            ),
          ),
          trailing: Icon(
            task["completed"] ? Icons.check_box : Icons.check_box_outline_blank,
            color: task["completed"] ? Colors.red : Colors.grey, // Checkbox color
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
          content: TextField(
            decoration: const InputDecoration(hintText: "Enter task here"),
            onChanged: (_value) {
              _newTaskContent = _value; // Update the task content
            },
          ),
          actions: [
            TextButton(
              child: const Text("Add"),
              onPressed: () {
                if (_newTaskContent != null && _newTaskContent!.isNotEmpty) {
                  _addTask(_newTaskContent!);
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

  void _addTask(String content) {
    final newTask = {
      "title": content,
      "completed": false, // New tasks are marked as not completed by default
    };
    setState(() {
      _tasks.add(newTask); // Add the task to the list
    });
  }
}