#ifndef JSON_PARSER_H
#define JSON_PARSER_H

// 북마크 1개를 담는 구조체
typedef struct {
    char post_id[50];      // 게시물 ID
    char caption[500];     // 캡션 텍스트
    char hashtags[200];    // 해시태그
    char image_path[200];  // 이미지 파일 경로
} Bookmark;

// JSON 파일 읽어서 Bookmark 배열로 반환
// filepath: JSON 파일 경로
// count: 몇 개 읽었는지 저장됨
Bookmark* load_bookmarks(const char* filepath, int* count);

// 메모리 해제
void free_bookmarks(Bookmark* bookmarks);

#endif