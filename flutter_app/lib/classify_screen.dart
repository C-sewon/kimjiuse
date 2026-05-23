import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'classifier_bridge.dart';

class ClassifyScreen extends StatefulWidget {
  @override
  _ClassifyScreenState createState() =>
      _ClassifyScreenState();
}

class _ClassifyScreenState
    extends State<ClassifyScreen> {

  final urlController = TextEditingController();
  List<Map<String, dynamic>> results = [];
  bool isLoading = false;
  String statusMessage = '';

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  Future<void> collectAndClassify() async {
    if (urlController.text.isEmpty) return;

    setState(() {
      isLoading = true;
      statusMessage = '데이터 수집 중...';
    });

    try {
      // 1. Python 서버에 URL 전송
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/collect'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'url': urlController.text
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          setState(() {
            statusMessage = 'C++ 분류 중...';
          });

          // 2. C++ 엔진으로 분류
          final result = classifyBookmark(
            data['caption'],
            data['hashtags'],
          );

          // 3. DB 저장
          saveBookmark(
            data['post_id'],
            result['category'],
            result['confidence'],
          );

          // 4. 화면 업데이트
          setState(() {
            results.insert(0, {
              'post_id': data['post_id'],
              'caption': data['caption'],
              'hashtags': data['hashtags'],
              'category': result['category'],
              'confidence': result['confidence'],
            });
            statusMessage = '분류 완료!';
            isLoading = false;
            urlController.clear();
          });
        } else {
          setState(() {
            statusMessage = data['message'];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        statusMessage = '서버 연결 실패: 서버를 먼저 실행해주세요';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('북마크 분류'),
        backgroundColor: Color(0xFF7F77DD),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // URL 입력창
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                hintText: '인스타그램 URL 입력',
                hintStyle: TextStyle(
                    color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 12),

            // 분류 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : collectAndClassify,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color(0xFF7F77DD),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                      vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(statusMessage),
                        ],
                      )
                    : Text('분류하기'),
              ),
            ),

            // 상태 메시지
            if (statusMessage.isNotEmpty &&
                !isLoading)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  statusMessage,
                  style: TextStyle(
                    color: statusMessage.contains('실패')
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ),

            SizedBox(height: 16),

            // 결과 목록
            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Text('📌',
                              style: TextStyle(
                                  fontSize: 50)),
                          SizedBox(height: 16),
                          Text(
                            '인스타그램 URL을 입력하면\nAI가 자동으로 분류해드립니다',
                            textAlign:
                                TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (ctx, i) {
                        return Card(
                          margin: EdgeInsets.only(
                              bottom: 8),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    12),
                          ),
                          child: ListTile(
                            contentPadding:
                                EdgeInsets.all(12),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xFF7F77DD)
                                    .withOpacity(0.2),
                                borderRadius:
                                    BorderRadius
                                        .circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  _getCategoryIcon(
                                      results[i]
                                          ['category']),
                                  style: TextStyle(
                                      fontSize: 24),
                                ),
                              ),
                            ),
                            title: Text(
                              results[i]['category'],
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              results[i]['caption'],
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,
                            ),
                            trailing: Text(
                              '${(results[i]['confidence'] * 100).toStringAsFixed(0)}%',
                              style: TextStyle(
                                color:
                                    Color(0xFF7F77DD),
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryIcon(String category) {
    switch (category) {
      case '맛집':    return '🍔';
      case '개발':    return '💻';
      case '여행':    return '✈️';
      case '운동':    return '💪';
      case '패션':    return '👗';
      case '뷰티':    return '💄';
      case '반려동물': return '🐶';
      case '인테리어': return '🏠';
      case '독서':    return '📚';
      default:       return '📌';
    }
  }

  @override
  void dispose() {
    urlController.dispose();
    closeDatabase();
    super.dispose();
  }
}