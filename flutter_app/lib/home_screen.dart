import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'category_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, String> categoryIcons = {
    '맛집': '🍔', '개발': '💻', '여행': '✈️', '운동': '💪', '패션': '👗',
    '뷰티': '💄', '반려동물': '🐶', '인테리어': '🏠', '독서': '📚', '기타': '📌',
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
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/bookmarks'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final bookmarks = data['bookmarks'] as List;

        Map<String, Map<String, dynamic>> categoryDataMap = {};

        for (var bookmark in bookmarks.reversed) {
          String category = bookmark['category'] ?? '기타';
          String imageUrl = bookmark['image_url'] ?? '';

          if (!categoryDataMap.containsKey(category)) {
            categoryDataMap[category] = {'count': 0, 'images': <String>[]};
          }

          categoryDataMap[category]!['count'] += 1;

          if (imageUrl.isNotEmpty && (categoryDataMap[category]!['images'] as List).length < 4) {
            (categoryDataMap[category]!['images'] as List<String>).add(imageUrl);
          }
        }

        List<Map<String, dynamic>> newCategories = [];
        categoryDataMap.forEach((name, data) {
          newCategories.add({
            'name': name,
            'icon': categoryIcons[name] ?? '📌',
            'count': data['count'],
            'images': data['images'],
          });
        });

        newCategories.sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));

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

  Widget buildFourGridImage(List<dynamic> images, String defaultIcon) {
    if (images.isEmpty) {
      return Center(child: Text(defaultIcon, style: const TextStyle(fontSize: 32)));
    }

    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        if (index >= images.length) {
          return Container(color: const Color(0xFFEFEFEF));
        }
        return Image.network(
          images[index],
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(color: const Color(0xFFEFEFEF)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      appBar: AppBar(
        title: Text(
          '내 북마크',
          style: GoogleFonts.notoSansKr(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFB1A2EE),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFB1A2EE)))
          : categories.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('📌', style: TextStyle(fontSize: 64)),
                      const SizedBox(height: 16),
                      Text(
                        '아직 분류된 북마크가 없어요.',
                        style: GoogleFonts.notoSansKr(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF222222),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "오른쪽 하단의 '분류' 탭을 눌러\n새로운 링크를 분석하고 정리해 보세요!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoSansKr(
                          fontSize: 13,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (ctx, i) {
                    final List<dynamic> currentImages = categories[i]['images'] ?? [];
                    final String categoryName = categories[i]['name'] as String;

                    return GestureDetector(
                      onTap: () async {
                        final bool? isChanged = await Navigator.push(
                          ctx,
                          MaterialPageRoute(
                            builder: (_) => CategoryScreen(categoryName, categories[i]['icon'] as String),
                          ),
                        );
                        if (isChanged == true) loadCategories();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Container(
                                color: const Color(0xFFF7F4EB),
                                child: buildFourGridImage(currentImages, categories[i]['icon'] as String),
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha:0.1),
                                      Colors.black.withValues(alpha:0.65),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 10, bottom: 10, right: 10,
                              child: Text(
                                categoryName,
                                style: GoogleFonts.notoSansKr(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 76),
        child: FloatingActionButton(
          onPressed: () {
            setState(() => isLoading = true);
            loadCategories();
          },
          backgroundColor: const Color(0xFFB4D3D9),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(Icons.refresh, size: 26),
        ),
      ),
    );
  }
}