import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'classifier_bridge.dart';

class ClassifyScreen extends StatefulWidget {
  const ClassifyScreen({super.key});

  @override
  State<ClassifyScreen> createState() => _ClassifyScreenState();
}

class _ClassifyScreenState extends State<ClassifyScreen> {
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
      // 🌟 [원천 차단 1단계] 입력된 URL에서 인스타그램 고유 post_id(또는 shortcode) 추출 시도
      // 예: instagram.com/p/C4bcDE/ -> C4bcDE 추출
      final RegExp regExp = RegExp(
        r'(?:https?:\/\/)?(?:www\.)?instagram\.com\/(?:p|reels|reel)\/([^\/?#&]+)',
        caseSensitive: false,
      );
      final Match? match = regExp.firstMatch(urlController.text);
      
      if (match != null && match.groupCount >= 1) {
        final String inputPostId = match.group(1)!;

        // 🌟 [원천 차단 2단계] 서버에서 전체 북마크 목록을 가져와 기저장 여부 검사
        final checkResponse = await http.get(Uri.parse('http://127.0.0.1:8000/bookmarks'));
        if (checkResponse.statusCode == 200) {
          final checkData = jsonDecode(checkResponse.body);
          final existingBookmarks = checkData['bookmarks'] as List;
          
          bool isAlreadySaved = existingBookmarks.any((b) => b['post_id'] == inputPostId);
          
          if (isAlreadySaved) {
            setState(() {
              statusMessage = '실패: 이미 분류가 완료된 북마크입니다.';
              isLoading = false;
              urlController.clear();
            });
            return;
          }
        }
      }

      // 1. Python 서버에 URL 전송
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/collect'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'url': urlController.text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          final String newPostId = data['post_id'] ?? '';

          // 🌟 혹시 몰라 한 번 더 화면단 중복 더블 체크
          bool isDuplicate = results.any((item) => item['post_id'] == newPostId);

          if (isDuplicate) {
            setState(() {
              statusMessage = '실패: 이미 분류가 완료된 북마크입니다.';
              isLoading = false;
              urlController.clear();
            });
            return;
          }

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

          // 4. Python 서버 JSON에도 저장
          await http.post(
            Uri.parse('http://127.0.0.1:8000/save'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'post_id': data['post_id'],
              'caption': data['caption'],
              'hashtags': data['hashtags'],
              'category': result['category'],
              'confidence': result['confidence'],
              'image_url': data['image_url'] ?? '',
            }),
          );

          // 5. 화면 업데이트
          setState(() {
            results.insert(0, {
              'post_id': data['post_id'],
              'caption': data['caption'],
              'hashtags': data['hashtags'],
              'category': result['category'],
              'confidence': result['confidence'],
              'image_url': data['image_url'] ?? '',
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
      backgroundColor: const Color(0xFFFAFAFC),
      appBar: AppBar(
        title: Text(
          '북마크 분류',
          style: GoogleFonts.notoSansKr(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFB1A2EE),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: urlController,
                      style: GoogleFonts.notoSansKr(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: '인스타그램 URL 입력',
                        hintStyle: GoogleFonts.notoSansKr(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: isLoading ? null : collectAndClassify,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isLoading ? const Color(0xFFE0E0E0) : const Color(0xFFB1A2EE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              '분류',
                              style: GoogleFonts.notoSansKr(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            if (statusMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusMessage.contains('실패') 
                        ? Colors.red.withValues(alpha: 0.1) 
                        : const Color(0xFFB1A2EE).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    statusMessage,
                    style: GoogleFonts.notoSansKr(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusMessage.contains('실패') ? Colors.red : const Color(0xFF7F67E2),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('📂', style: TextStyle(fontSize: 56)),
                          const SizedBox(height: 16),
                          Text(
                            '분류할 인스타그램 게시물 또는 릴스 링크를 넣어보세요',
                            style: GoogleFonts.notoSansKr(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'AI 엔진이 수집 정보와 해시태그를 대조하여\n스마트하게 매칭 카테고리를 찾아냅니다.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansKr(
                              color: Colors.grey,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: results.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (ctx, i) {
                        final String categoryName = results[i]['category'];
                        final String currentIcon = _getCategoryIcon(categoryName);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 1.6,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF7F7FA),
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: results[i]['image_url'] != null && results[i]['image_url'] != ''
                                            ? ClipRRect(
                                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                                child: Image.network(
                                                  results[i]['image_url'],
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) => Center(
                                                    child: Text(currentIcon, style: const TextStyle(fontSize: 48)),
                                                  ),
                                                ),
                                              )
                                            : Center(
                                                child: Text(currentIcon, style: const TextStyle(fontSize: 48)),
                                              ),
                                      ),
                                      Positioned(
                                        left: 14,
                                        top: 14,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withValues(alpha: 0.6),
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('$currentIcon ', style: const TextStyle(fontSize: 13)),
                                              Text(
                                                categoryName,
                                                style: GoogleFonts.notoSansKr(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 14,
                                        top: 14,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFB1A2EE),
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          child: Text(
                                            '${(results[i]['confidence'] * 100).toStringAsFixed(0)}% Match',
                                            style: GoogleFonts.notoSansKr(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      results[i]['caption'].toString().trim().isEmpty
                                          ? '본문 내용이 없는 북마크입니다.'
                                          : results[i]['caption'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.notoSansKr(
                                        fontSize: 14,
                                        color: const Color(0xFF333333),
                                        fontWeight: FontWeight.w500,
                                        height: 1.4,
                                      ),
                                    ),
                                    if (results[i]['hashtags'] != null && results[i]['hashtags'].toString().isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          results[i]['hashtags'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.notoSansKr(
                                            fontSize: 12,
                                            color: const Color(0xFF7F67E2),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
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
      case '맛집':     return '🍔';
      case '개발':     return '💻';
      case '여행':     return '✈️';
      case '운동':     return '💪';
      case '패션':     return '👗';
      case '뷰티':     return '💄';
      case '반려동물':  return '🐶';
      case '인테리어':  return '🏠';
      case '독서':     return '📚';
      default:        return '📌';
    }
  }

  @override
  void dispose() {
    urlController.dispose();
    closeDatabase();
    super.dispose();
  }
}