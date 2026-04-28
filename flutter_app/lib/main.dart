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
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
        cardColor: Color(0xFF1E1E2E),
        scaffoldBackgroundColor: Color(0xFF13131F),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final urlController = TextEditingController();

  final categories = [
    {'name': '맛집',    'icon': '🍔', 'count': 12},
    {'name': '개발',    'icon': '💻', 'count': 8},
    {'name': '여행',    'icon': '✈️',  'count': 15},
    {'name': '운동',    'icon': '💪', 'count': 6},
    {'name': '패션',    'icon': '👗', 'count': 4},
    {'name': '뷰티',    'icon': '💄', 'count': 3},
    {'name': '반려동물', 'icon': '🐶', 'count': 5},
    {'name': '인테리어', 'icon': '🏠', 'count': 2},
    {'name': '독서',    'icon': '📚', 'count': 7},
    {'name': '기타',    'icon': '📌', 'count': 3},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 북마크'),
        centerTitle: true,
        backgroundColor: Color(0xFF1E1E2E),
      ),
      body: Column(
        children: [
          // URL 입력창
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: urlController,
                    decoration: InputDecoration(
                      hintText: '인스타그램 URL 입력',
                      hintStyle: TextStyle(
                          color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Color(0xFF1E1E2E),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // 나중에 C++ 엔진 연결
                    print("URL: ${urlController.text}");
                    urlController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('분류'),
                ),
              ],
            ),
          ),

          // 카테고리 목록
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                  horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (ctx, i) {
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.indigo
                            .withOpacity(0.2),
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          categories[i]['icon']
                              as String,
                          style: TextStyle(
                              fontSize: 24),
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
                      style: TextStyle(
                          color: Colors.grey),
                    ),
                    trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16),
                    onTap: () {
                      Navigator.push(
                        ctx,
                        MaterialPageRoute(
                          builder: (_) =>
                              CategoryScreen(
                            categories[i]['name']
                                as String,
                            categories[i]['icon']
                                as String,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

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
      appBar: AppBar(
        title: Text('$icon $category'),
        backgroundColor: Color(0xFF1E1E2E),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: posts.length,
        itemBuilder: (ctx, i) {
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(12),
              title: Text(posts[i]['caption']!),
              subtitle: Text(
                posts[i]['tag']!,
                style: TextStyle(
                    color: Colors.indigo[300]),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit,
                    color: Colors.grey),
                onPressed: () {
                  showDialog(
                    context: ctx,
                    builder: (_) => AlertDialog(
                      title: Text('카테고리 수정'),
                      content: Text(
                          '다른 카테고리로 이동할까요?'),
                      actions: [
                        TextButton(
                          child: Text('취소'),
                          onPressed: () =>
                              Navigator.pop(ctx),
                        ),
                        TextButton(
                          child: Text('확인'),
                          onPressed: () =>
                              Navigator.pop(ctx),
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