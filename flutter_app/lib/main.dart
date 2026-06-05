import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const BookmarkApp());
}

class BookmarkApp extends StatelessWidget {
  const BookmarkApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color brandColor = Color(0xFFB1A2EE);

    return MaterialApp(
      title: '북마크 분류기',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFAFAFC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandColor,
          primary: brandColor,
          surface: const Color(0xFFFAFAFC),
        ),
      ),
      home: SplashScreen(),
    );
  }
}