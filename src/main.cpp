#include <stdio.h>
#include "db_handler.h"

int main() {
    printf("=== 북마크 분류기 시작 ===\n");

    db_init("data/bookmarks.db");

    db_insert("post_001", "맛집", 0.95f);
    db_insert("post_002", "여행", 0.87f);
    db_insert("post_003", "개발", 0.91f);

    db_update_category("post_001", "카페");

    db_close();

    printf("=== 완료 ===\n");
    return 0;
}