import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'classify_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final screens = [
    HomeScreen(),
    ClassifyScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Color(0xFF7F77DD),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.link),
            label: '분류',
          ),
        ],
      ),
    );
  }
}