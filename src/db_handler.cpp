#include "db_handler.h"
#include "logger.h"
#include <sqlite3.h>
#include <stdio.h>
#include <string.h>

static sqlite3* db = NULL;

int db_init(const char* db_path) {
    logger_init("data/app.log");

    int rc = sqlite3_open(db_path, &db);
    if (rc != SQLITE_OK) {
        LOG_ERROR("DB 열기 실패");
        printf("DB 열기 실패: %s\n",
               sqlite3_errmsg(db));
        return -1;
    }

    // 테이블 생성
    const char* sql =
        "CREATE TABLE IF NOT EXISTS bookmarks("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "post_id TEXT NOT NULL,"
        "category TEXT NOT NULL,"
        "confidence REAL,"
        "caption TEXT,"
        "hashtags TEXT"
        ");";

    char* err_msg = NULL;
    rc = sqlite3_exec(db, sql, 0, 0, &err_msg);

    if (rc != SQLITE_OK) {
        LOG_ERROR("테이블 생성 실패");
        printf("테이블 생성 실패: %s\n", err_msg);
        sqlite3_free(err_msg);
        return -1;
    }

    LOG_INFO("DB 초기화 완료");
    printf("DB 초기화 완료: %s\n", db_path);
    return 0;
}

int db_insert(const char* post_id,
              const char* category,
              float confidence) {
    if (db == NULL) {
        LOG_ERROR("DB가 초기화되지 않음");
        printf("오류: DB가 초기화되지 않음\n");
        return -1;
    }

    char msg[100];
    sprintf(msg, "저장: %s -> %s",
            post_id, category);
    LOG_INFO(msg);

    char sql[500];
    sprintf(sql,
        "INSERT INTO bookmarks "
        "(post_id, category, confidence) "
        "VALUES ('%s', '%s', %.2f);",
        post_id, category, confidence);

    char* err_msg = NULL;
    int rc = sqlite3_exec(db, sql,
                          0, 0, &err_msg);

    if (rc != SQLITE_OK) {
        LOG_ERROR("저장 실패");
        printf("저장 실패: %s\n", err_msg);
        sqlite3_free(err_msg);
        return -1;
    }

    printf("저장 완료: %s → %s (%.0f%%)\n",
           post_id, category, confidence * 100);
    return 0;
}

int db_update_category(const char* post_id,
                       const char* new_category) {
    if (db == NULL) return -1;

    char sql[300];
    sprintf(sql,
        "UPDATE bookmarks "
        "SET category = '%s' "
        "WHERE post_id = '%s';",
        new_category, post_id);

    char* err_msg = NULL;
    int rc = sqlite3_exec(db, sql,
                          0, 0, &err_msg);

    if (rc != SQLITE_OK) {
        LOG_ERROR("수정 실패");
        printf("수정 실패: %s\n", err_msg);
        sqlite3_free(err_msg);
        return -1;
    }

    printf("수정 완료: %s → %s\n",
           post_id, new_category);
    return 0;
}

char** db_query_by_category(const char* category,
                             int* result_count) {
    if (db == NULL) {
        *result_count = 0;
        return NULL;
    }

    char msg[100];
    sprintf(msg, "조회: %s 카테고리", category);
    LOG_INFO(msg);

    *result_count = 0;
    return NULL;
}

void db_close(void) {
    if (db != NULL) {
        sqlite3_close(db);
        db = NULL;
        LOG_INFO("DB 종료");
        printf("DB 종료\n");
        logger_close();
    }
}