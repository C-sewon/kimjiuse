import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'category_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final Map<String, String> categoryIcons = {
    '맛집':    '🍔',
    '개발':    '💻',
    '여행':    '✈️',
    '운동':    '💪',
    '패션':    '👗',
    '뷰티':    '💄',
    '반려동물': '🐶',
    '인테리어': '🏠',
    '독서':    '📚',
    '기타':    '📌',
  };

  List<Map<String, dynamic>> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadCategories();  // 탭 이동할 때마다 실행
  }
  
  // 서버에서 북마크 데이터 불러오기
  Future<void> loadCategories() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/bookmarks'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final bookmarks = data['bookmarks'] as List;

        // 카테고리별 count 계산
        Map<String, int> countMap = {};
        for (var bookmark in bookmarks) {
          String category = bookmark['category'] ?? '기타';
          countMap[category] = (countMap[category] ?? 0) + 1;
        }

        // 카테고리 목록 생성
        List<Map<String, dynamic>> newCategories = [];

        // countMap에 존재하는(게시물이 있는) 카테고리만 추가합니다.
        countMap.forEach((name, count) {
          String icon = categoryIcons[name] ?? '📌';
          
          newCategories.add({
            'name': name,
            'icon': icon,
            'count': count,
          });
        });

        // count 기준으로 내림차순 정렬 (게시물이 많은 순서대로)
        newCategories.sort((a, b) =>
            (b['count'] as int).compareTo(a['count'] as int));

        setState(() {
          categories = newCategories;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        categories = []; 
        isLoading = false;
      });
    }
  }

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
        actions: [
          // 수동 새로고침 버튼
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              loadCategories();
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Color(0xFF7F77DD),
              ),
            )
          : ListView.builder(
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
                        borderRadius:
                            BorderRadius.circular(12),
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
                    trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16),
                    // 🔥 변경된 핵심 포인트: 비동기 처리 및 신호 감지 로직 적용
                    onTap: () async {
                      // 1. 카테고리 화면으로 진입하면서 닫힐 때 던져주는 true 신호를 기다립니다(await).
                      final bool? isChanged = await Navigator.push(
                        ctx,
                        MaterialPageRoute(
                          builder: (_) => CategoryScreen(
                            categories[i]['name'] as String,
                            categories[i]['icon'] as String,
                          ),
                        ),
                      );

                      // 2. 카테고리 화면이 true를 던지며 복귀했다면 홈 화면을 즉시 새로고침 합니다!
                      if (isChanged == true) {
                        print("카테고리 수정/삭제 신호 확인! 홈 화면 데이터를 자동 갱신합니다.");
                        loadCategories();
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}