#include "../include/db_handler.h"
#include <stdio.h>
#include <stdlib.h>

// 나중에 SQLite 설치 후 추가할 부분
// #include <sqlite3.h>

// 일단 테스트용으로 printf만 써서 확인
int db_init(const char* db_path) {
    printf("DB 초기화: %s\n", db_path);
    return 0;
}

int db_insert(const char* post_id,
              const char* category,
              float confidence) {
    printf("저장: %s → %s (%.1f%%)\n",
           post_id, category, confidence * 100);
    return 0;
}

int db_update_category(const char* post_id,
                       const char* new_category) {
    printf("수정: %s → %s\n", post_id, new_category);
    return 0;
}

void db_close(void) {
    printf("DB 종료\n");
}