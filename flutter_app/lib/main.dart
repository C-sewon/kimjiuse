import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(BookmarkApp());
}

class BookmarkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '북마크 분류기',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor : Color(0xFF7F77DD),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF7F77DD),
        )
      ),
      home: SplashScreen(),
    );
  }
}