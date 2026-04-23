#include <stdio.h>
#include "db_handler.h"
#include "json_parser.h"
#include "text_classifier.h"
#include "image_analyzer.h"

int main() {
    printf("=== 북마크 분류기 시작 ===\n\n");

    // 1. DB 초기화
    db_init("data/bookmarks.db");

    // 2. JSON에서 북마크 읽기
    int count = 0;
    Bookmark* bookmarks = load_bookmarks(
        "data/bookmarks.json", &count);

    printf("\n=== 분류 시작 ===\n\n");

    // 3. 각 북마크 분류
    for (int i = 0; i < count; i++) {

        // 텍스트 분류
        ClassifyResult text_result = classify_text(
            bookmarks[i].caption,
            bookmarks[i].hashtags);

        // 이미지 분류
        ImageLabels img_result = analyze_image(
            bookmarks[i].image_path);

        // DB 저장
        db_insert(bookmarks[i].post_id,
                  text_result.category,
                  text_result.confidence);

        printf("게시물 [%s]\n", bookmarks[i].post_id);
        printf("캡션: %s\n", bookmarks[i].caption);
        printf("해시태그: %s\n", bookmarks[i].hashtags);
        printf("분류 결과: %s (%.0f%%)\n\n",
               text_result.category,
               text_result.confidence * 100);
    }

    printf("=== 완료 ===\n");

    // 4. 메모리 해제
    free_bookmarks(bookmarks);
    db_close();

    return 0;
}