import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  final String icon;

  const CategoryScreen(this.category, this.icon, {super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Map<String, dynamic>> posts = [];
  bool isLoading = true;
  bool isAnyDeleted = false;

  bool isEditMode = false;
  Set<String> selectedPostIds = {};

  final List<String> allCategories = [
    '맛집', '개발', '여행', '운동', '패션', '뷰티', '반려동물', '인테리어', '독서', '기타'
  ];

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<void> loadPosts() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/bookmarks'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final bookmarks = data['bookmarks'] as List;

        final filtered = bookmarks.where((b) =>
            b['category'] == widget.category
        ).toList();

        setState(() {
          posts = filtered
              .map<Map<String, dynamic>>((b) => {
                'post_id': b['post_id'] ?? '',
                'caption': b['caption'] ?? '',
                'hashtags': b['hashtags'] ?? '',
                'image_url': b['image_url'] ?? '',
              })
              .toList();
          isLoading = false;
          isEditMode = false;
          selectedPostIds.clear();
        });
      }
    } catch (e) {
      setState(() {
        posts = [];
        isLoading = false;
      });
    }
  }

  Future<void> deleteMultiplePosts() async {
    try {
      setState(() => isLoading = true);

      for (String postId in selectedPostIds) {
        await http.delete(Uri.parse('http://127.0.0.1:8000/bookmarks/$postId'));
      }

      isAnyDeleted = true;
      loadPosts();
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> updateMultipleCategories(String newCategory) async {
    try {
      setState(() => isLoading = true);

      for (String postId in selectedPostIds) {
        final post = posts.firstWhere((p) => p['post_id'] == postId);

        await http.delete(Uri.parse('http://127.0.0.1:8000/bookmarks/$postId'));

        await http.post(
          Uri.parse('http://127.0.0.1:8000/save'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "post_id": post['post_id'],
            "caption": post['caption'],
            "hashtags": post['hashtags'],
            "category": newCategory,
            "confidence": 1.0,
            "image_url": post['image_url'],
          }),
        );
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void showBulkDeleteConfirmDialog() {
    if (selectedPostIds.isEmpty) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('게시물 일괄 삭제', style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold)),
        content: Text(
          '선택한 ${selectedPostIds.length}개의 게시물을 정말로 삭제하시겠습니까?\n삭제된 데이터는 복구할 수 없습니다.',
          style: GoogleFonts.notoSansKr(fontSize: 14, height: 1.4)
        ),
        actions: [
          TextButton(
            child: Text('취소', style: GoogleFonts.notoSansKr(color: Colors.grey)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('삭제', style: GoogleFonts.notoSansKr(color: Colors.red, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.pop(context);
              deleteMultiplePosts();
            },
          ),
        ],
      ),
    );
  }

  void showBulkCategorySelectDialog() {
    if (selectedPostIds.isEmpty) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          '${selectedPostIds.length}개의 게시물 이동',
          style: GoogleFonts.notoSansKr(fontWeight: FontWeight.bold)
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 250,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: allCategories.length,
            itemBuilder: (context, index) {
              final targetCategory = allCategories[index];
              if (targetCategory == widget.category) return const SizedBox.shrink();

              return ListTile(
                title: Text(targetCategory, style: GoogleFonts.notoSansKr()),
                onTap: () {
                  Navigator.pop(context);
                  updateMultipleCategories(targetCategory);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            child: Text('취소', style: GoogleFonts.notoSansKr(color: Colors.grey)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasSelection = selectedPostIds.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '${widget.icon} ${widget.category}',
          style: GoogleFonts.notoSansKr(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFB1A2EE),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, isAnyDeleted ? true : null),
        ),
        actions: [
          if (posts.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() {
                  isEditMode = !isEditMode;
                  selectedPostIds.clear();
                });
              },
              child: Text(
                isEditMode ? '취소' : '선택',
                style: GoogleFonts.notoSansKr(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFB1A2EE)))
          : posts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.icon, style: const TextStyle(fontSize: 50)),
                      const SizedBox(height: 16),
                      Text(
                        '아직 분류된 게시물이 없어요',
                        style: GoogleFonts.notoSansKr(color: Colors.grey, fontSize: 15),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(2),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: posts.length,
                  itemBuilder: (ctx, i) {
                    final postId = posts[i]['post_id'];
                    final isSelected = selectedPostIds.contains(postId);
                    final hasImage = posts[i]['image_url'] != null && posts[i]['image_url'] != '';

                    return GestureDetector(
                      onTap: () async {
                        if (isEditMode) {
                          setState(() {
                            if (isSelected) {
                              selectedPostIds.remove(postId);
                            } else {
                              selectedPostIds.add(postId);
                            }
                          });
                        } else {
                          final uri = Uri.parse('https://www.instagram.com/p/${posts[i]['post_id']}/');
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        }
                      },
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              color: Colors.white,
                              child: hasImage
                                  ? Image.network(
                                      posts[i]['image_url'],
                                      fit: BoxFit.cover,
                                    )
                                  : Center(
                                      child: Text(
                                        widget.icon,
                                        style: const TextStyle(fontSize: 32),
                                      ),
                                    ),
                            ),
                          ),
                          if (isEditMode) ...[
                            Positioned.fill(
                              child: Container(
                                color: isSelected
                                    ? const Color(0xFFB1A2EE).withValues(alpha: 0.4)
                                    : Colors.black.withValues(alpha: 0.25),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Icon(
                                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                                color: isSelected ? Colors.white : Colors.white70,
                                size: 22,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: AnimatedScale(
        scale: isEditMode ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn,
        child: FloatingActionButton(
          onPressed: () {
            setState(() => isLoading = true);
            loadPosts();
          },
          backgroundColor: const Color(0xFFB4D3D9),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(Icons.refresh, size: 26),
        ),
      ),
      bottomNavigationBar: isEditMode
          ? SafeArea(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFB1A2EE),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Text(
                      '${selectedPostIds.length}개 선택',
                      style: GoogleFonts.notoSansKr(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: hasSelection ? Colors.red : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: hasSelection
                            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 2))]
                            : [],
                      ),
                      child: InkWell(
                        onTap: hasSelection ? showBulkDeleteConfirmDialog : null,
                        borderRadius: BorderRadius.circular(12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.delete,
                              color: hasSelection ? Colors.white : Colors.white.withValues(alpha: 0.5),
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '삭제',
                              style: GoogleFonts.notoSansKr(
                                fontWeight: FontWeight.bold,
                                color: hasSelection ? Colors.white : Colors.white.withValues(alpha: 0.5),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: hasSelection
                            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 4, offset: const Offset(0, 2))]
                            : [],
                      ),
                      child: TextButton.icon(
                        icon: Icon(
                          Icons.drive_file_move, 
                          size: 16,
                          color: hasSelection ? const Color(0xFF806EE3) : Colors.white.withValues(alpha: 0.4),
                        ),
                        label: Text(
                          '이동', 
                          style: GoogleFonts.notoSansKr(
                            fontWeight: FontWeight.bold,
                            color: hasSelection ? const Color(0xFF806EE3) : Colors.white.withValues(alpha: 0.4),
                          )
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: hasSelection
                              ? const Color(0xFFF7F4EB)
                              : Colors.white.withValues(alpha: 0.15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        ),
                        onPressed: hasSelection ? showBulkCategorySelectDialog : null,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}