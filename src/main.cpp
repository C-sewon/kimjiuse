#include <stdio.h>
#include "json_parser.h"
#include "text_classifier.h"
#include "image_analyzer.h"
#include "db_handler.h"

int main() {
    printf("=== 북마크 분류기 시작 ===\n");

    // 1. DB 초기화
    db_init("data/bookmarks.db");

    // 2. JSON에서 북마크 읽기 (팀원 A 구현)
    int count = 0;
    Bookmark* bookmarks = load_bookmarks(
        "data/bookmarks.json", &count);

    // 3. 각 북마크 분류
    for (int i = 0; i < count; i++) {
        // 텍스트 분류 (팀원 B 구현)
        ClassifyResult text_result = classify_text(
            bookmarks[i].caption,
            bookmarks[i].hashtags);

        // 이미지 분류 (팀원 C 구현)
        ImageLabels img_result = analyze_image(
            bookmarks[i].image_path);

        // DB 저장 (팀장 구현)
        db_insert(bookmarks[i].post_id,
                  text_result.category,
                  text_result.confidence);

        printf("게시물 %s → %s (%.1f%%)\n",
               bookmarks[i].post_id,
               text_result.category,
               text_result.confidence * 100);
    }

    // 4. 메모리 해제
    free_bookmarks(bookmarks);
    db_close();

    printf("=== 완료 ===\n");
    return 0;
}