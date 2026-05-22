import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final String category;
  final String icon;
  CategoryScreen(this.category, this.icon);

  final posts = [
    {'caption': '오늘 점심 너무 맛있었다', 'tag': '#맛집'},
    {'caption': '강남 새로운 카페 발견',   'tag': '#카페'},
    {'caption': '주말 브런치 추천',        'tag': '#브런치'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('$icon $category'),
        backgroundColor: Color(0xFF7F77DD),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: posts.length,
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
              title: Text(posts[i]['caption']!),
              subtitle: Text(
                posts[i]['tag']!,
                style: TextStyle(color: Color(0xFF7F77DD)),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.grey),
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