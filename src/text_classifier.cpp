#include "text_classifier.h"
#include <string.h>
#include <stdio.h>

ClassifyResult classify_text(const char* caption,
                              const char* hashtags) {
    ClassifyResult result;
    result.confidence = 0.9f;

    // 맛집 키워드
    if (strstr(caption, "맛집") ||
        strstr(hashtags, "맛집") ||
        strstr(caption, "점심") ||
        strstr(caption, "카페") ||
        strstr(caption, "food") ||
        strstr(hashtags, "food")) {
        strcpy(result.category, "맛집");
    }
    // 개발 키워드
    else if (strstr(caption, "개발") ||
             strstr(hashtags, "개발") ||
             strstr(caption, "코딩") ||
             strstr(caption, "coding") ||
             strstr(hashtags, "coding") ||
             strstr(hashtags, "github")) {
        strcpy(result.category, "개발");
    }
    // 여행 키워드
    else if (strstr(caption, "여행") ||
             strstr(hashtags, "여행") ||
             strstr(caption, "제주도") ||
             strstr(caption, "바다") ||
             strstr(caption, "travel") ||
             strstr(hashtags, "travel")) {
        strcpy(result.category, "여행");
    }
    // 운동 키워드
    else if (strstr(caption, "운동") ||
             strstr(hashtags, "운동") ||
             strstr(caption, "헬스") ||
             strstr(hashtags, "헬스") ||
             strstr(caption, "fitness") ||
             strstr(hashtags, "fitness")) {
        strcpy(result.category, "운동");
    }
    // 해당 없으면 기타
    else {
        strcpy(result.category, "기타");
        result.confidence = 0.5f;
    }

    return result;
}

void update_feedback(const char* keyword,
                     const char* correct_category) {
    printf("피드백 반영: %s → %s\n",
           keyword, correct_category);
}