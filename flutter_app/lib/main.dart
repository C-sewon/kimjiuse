import 'package:flutter/material.dart';

void main() {
  runApp(BookmarkApp());
}

class BookmarkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '북마크 분류기',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: HomeScreen(),
    );
  }
}

// 홈화면 - 카테고리 목록
class HomeScreen extends StatelessWidget {
  final categories = [
    {'name': '맛집', 'icon': '🍔', 'count': 12},
    {'name': '개발', 'icon': '💻', 'count': 8},
    {'name': '여행', 'icon': '✈️', 'count': 15},
    {'name': '운동', 'icon': '💪', 'count': 6},
    {'name': '기타', 'icon': '📌', 'count': 3},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 북마크'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (ctx, i) {
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Text(
                categories[i]['icon'] as String,
                style: TextStyle(fontSize: 30),
              ),
              title: Text(
                categories[i]['name'] as String,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${categories[i]['count']}개의 게시물'
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  ctx,
                  MaterialPageRoute(
                    builder: (_) => CategoryScreen(
                      categories[i]['name'] as String
                    )
                  )
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// 카테고리별 게시물 목록
class CategoryScreen extends StatelessWidget {
  final String category;
  CategoryScreen(this.category);

  final posts = [
    {'caption': '오늘 점심 너무 맛있었다', 'tag': '#맛집'},
    {'caption': '강남 새로운 카페 발견',   'tag': '#카페'},
    {'caption': '주말 브런치 추천',        'tag': '#브런치'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: posts.length,
        itemBuilder: (ctx, i) {
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(posts[i]['caption']!),
              subtitle: Text(posts[i]['tag']!),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                    context: ctx,
                    builder: (_) => AlertDialog(
                      title: Text('카테고리 수정'),
                      content: Text('다른 카테고리로 이동할까요?'),
                      actions: [
                        TextButton(
                          child: Text('취소'),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                        TextButton(
                          child: Text('확인'),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}