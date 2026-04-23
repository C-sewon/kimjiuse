#ifndef DB_HANDLER_H
#define DB_HANDLER_H

// DB 초기화 (앱 시작할 때 1번만 호출)
int db_init(const char* db_path);

// 북마크 분류 결과 저장
int db_insert(const char* post_id,
              const char* category,
              float confidence);

// 사용자가 카테고리 수정했을 때
int db_update_category(const char* post_id,
                       const char* new_category);

// 카테고리별 조회
// category: "맛집" 등
// result_count: 결과 개수 저장됨
char** db_query_by_category(const char* category,
                             int* result_count);

// DB 닫기
void db_close(void);

#endif