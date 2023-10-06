import 'package:flutter/material.dart';
import 'package:flutter_web/models/greeting.dart';
import 'package:flutter_web/screens/ai_assistant.dart';
import 'package:flutter_web/screens/fire_jobs.dart';
import 'package:flutter_web/screens/recent_jobs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.blue,
  ];
  final List _images = [
    "assets/chatfreely.jpg",
    "assets/chatfreely.jpg",
  ];
  final List<Widget> _screens = [
    ChatScreen(),
    FetchDataFromFirebase(),
  ];
  int _currentIndex = 0;

  final List<String> names = ["AI Assistant", "Recent Jobs"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 205, 205, 205),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'AI Assistant',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Jobs',
          ),
        ],
      ),
    );
  }
}
