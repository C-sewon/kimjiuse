import 'package:flutter/material.dart';
import 'category_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final categories = [
    {'name': '맛집',     'icon': '🍔', 'count': 12},
    {'name': '개발',     'icon': '💻', 'count': 8},
    {'name': '여행',     'icon': '✈️',  'count': 15},
    {'name': '운동',     'icon': '💪', 'count': 6},
    {'name': '패션',     'icon': '👗', 'count': 4},
    {'name': '뷰티',     'icon': '💄', 'count': 3},
    {'name': '반려동물', 'icon': '🐶', 'count': 5},
    {'name': '인테리어', 'icon': '🏠', 'count': 2},
    {'name': '독서',     'icon': '📚', 'count': 7},
    {'name': '기타',     'icon': '📌', 'count': 3},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('내 북마크',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        )),
        centerTitle: true,
        backgroundColor: Color(0xFF7F77DD),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (ctx, i) {
          return Card(
            color: const Color(0xFFF5F4ED),
            elevation: 0,
            margin: EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(12),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEDFE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    categories[i]['icon'] as String,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              title: Text(
                categories[i]['name'] as String,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${categories[i]['count']}개의 게시물',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  ctx,
                  MaterialPageRoute(
                    builder: (_) => CategoryScreen(
                      categories[i]['name'] as String,
                      categories[i]['icon'] as String,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}