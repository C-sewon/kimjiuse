#ifdef _WIN32
#include <windows.h>
#define EXPORT __declspec(dllexport)
#else
#define EXPORT
#endif

#include "text_classifier.h"
#include "db_handler.h"
#include "json_parser.h"
#include <stdio.h>
#include <string.h>

extern "C" {

// DB 초기화
EXPORT int init_db(const char* path) {
    return db_init(path);
}

// 분류 함수
// 결과: "카테고리:신뢰도" 형식 반환
// 예: "맛집:0.90"
EXPORT const char* classify_bookmark(
    const char* caption,
    const char* hashtags) {

    ClassifyResult result = classify_text(
        caption, hashtags);

    static char output[100];
    sprintf(output, "%s:%.2f",
            result.category,
            result.confidence);
    return output;
}

// 저장 함수
EXPORT int save_bookmark(
    const char* post_id,
    const char* category,
    float confidence) {

    return db_insert(post_id,
                     category,
                     confidence);
}

// DB 종료
EXPORT void close_db() {
    db_close();
}

}