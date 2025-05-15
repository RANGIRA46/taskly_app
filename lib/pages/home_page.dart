import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key}); // Added constructor and 'super.key'

  @override
  State<StatefulWidget> createState() => _HomePageState(); // Corrected the syntax
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight, _deviceWidth;
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(appBar: AppBar(
      toolbarHeight: _deviceHeight * 0.15,
      title: const Text("Taskly!", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
    )
    );
  }
}
