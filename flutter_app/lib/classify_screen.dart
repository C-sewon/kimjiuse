import 'package:flutter/material.dart';
import 'classifier_bridge.dart';

class ClassifyScreen extends StatefulWidget {
  @override
  _ClassifyScreenState createState() =>
      _ClassifyScreenState();
}

class _ClassifyScreenState
    extends State<ClassifyScreen> {

  final urlController = TextEditingController();
  final captionController = TextEditingController();
  final hashtagsController = TextEditingController();

  List<Map<String, dynamic>> results = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  void classify() {
    if (captionController.text.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    // C++ 분류 함수 호출
    final result = classifyBookmark(
      captionController.text,
      hashtagsController.text,
    );

    // DB 저장
    saveBookmark(
      'post_${DateTime.now().millisecondsSinceEpoch}',
      result['category'],
      result['confidence'],
    );

    setState(() {
      results.insert(0, {
        'caption': captionController.text,
        'hashtags': hashtagsController.text,
        'category': result['category'],
        'confidence': result['confidence'],
      });
      isLoading = false;
      captionController.clear();
      hashtagsController.clear();
    });
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
            // 캡션 입력
            TextField(
              controller: captionController,
              decoration: InputDecoration(
                hintText: '캡션 입력',
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 8),

            // 해시태그 입력
            TextField(
              controller: hashtagsController,
              decoration: InputDecoration(
                hintText: '해시태그 입력 (#맛집 #점심)',
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
                onPressed: isLoading ? null : classify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7F77DD),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                      vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white)
                    : Text('분류하기'),
              ),
            ),
            SizedBox(height: 16),

            // 결과 목록
            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Text(
                        '캡션과 해시태그를 입력하세요',
                        style: TextStyle(
                            color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (ctx, i) {
                        return Card(
                          margin: EdgeInsets.only(
                              bottom: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    12),
                          ),
                          child: ListTile(
                            title: Text(
                              results[i]['category'],
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                                results[i]['caption']),
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

  @override
  void dispose() {
    captionController.dispose();
    hashtagsController.dispose();
    urlController.dispose();
    closeDatabase();
    super.dispose();
  }
}