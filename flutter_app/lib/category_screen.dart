import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryScreen extends StatefulWidget {
  final String category;
  final String icon;
  CategoryScreen(this.category, this.icon);

  @override
  _CategoryScreenState createState() =>
      _CategoryScreenState();
}

class _CategoryScreenState
    extends State<CategoryScreen> {

  List<Map<String, dynamic>> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  // 서버에서 해당 카테고리 게시물 불러오기
  Future<void> loadPosts() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/bookmarks'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final bookmarks = data['bookmarks'] as List;

        // 해당 카테고리만 필터링
        final filtered = bookmarks.where((b) =>
            b['category'] == widget.category
        ).toList();

        setState(() {
          posts = filtered
              .map<Map<String, dynamic>>((b) => {
                'post_id': b['post_id'] ?? '',
                'caption': b['caption'] ?? '',
                'hashtags': b['hashtags'] ?? '',
              })
              .toList();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        posts = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('${widget.icon} ${widget.category}'),
        backgroundColor: Color(0xFF7F77DD),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() => isLoading = true);
              loadPosts();
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
          : posts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.icon,
                        style: TextStyle(fontSize: 50),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '아직 분류된 게시물이 없어요',
                        style: TextStyle(
                            color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: posts.length,
                  itemBuilder: (ctx, i) {
                    return Card(
                      color: const Color(0xFFF5F4ED),
                      elevation: 0,
                      margin:
                          EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.all(12),
                        title: Text(
                          posts[i]['caption'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          posts[i]['hashtags'],
                          style: TextStyle(
                              color: Color(0xFF7F77DD)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.edit,
                              color: Colors.grey),
                          onPressed: () {
                            showDialog(
                              context: ctx,
                              builder: (_) => AlertDialog(
                                title:
                                    Text('카테고리 수정'),
                                content: Text(
                                    '다른 카테고리로 이동할까요?'),
                                actions: [
                                  TextButton(
                                    child: Text('취소'),
                                    onPressed: () =>
                                        Navigator.pop(
                                            ctx),
                                  ),
                                  TextButton(
                                    child: Text('확인'),
                                    onPressed: () =>
                                        Navigator.pop(
                                            ctx),
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