#include "text_classifier.h"
#include "logger.h"
#include <string.h>
#include <stdio.h>

ClassifyResult classify_text(const char* caption,
                              const char* hashtags) {
    LOG_INFO("텍스트 분류 시작");

    ClassifyResult result;
    result.confidence = 0.9f;

    if (strstr(caption, "맛집") ||
        strstr(hashtags, "맛집") ||
        strstr(caption, "점심") ||
        strstr(caption, "카페") ||
        strstr(caption, "커피") ||
        strstr(caption, "food") ||
        strstr(hashtags, "food")) {
        strcpy(result.category, "맛집");
    }
    else if (strstr(caption, "개발") ||
             strstr(hashtags, "개발") ||
             strstr(caption, "코딩") ||
             strstr(caption, "coding") ||
             strstr(hashtags, "coding") ||
             strstr(hashtags, "github")) {
        strcpy(result.category, "개발");
    }
    else if (strstr(caption, "여행") ||
             strstr(hashtags, "여행") ||
             strstr(caption, "제주도") ||
             strstr(caption, "바다") ||
             strstr(caption, "travel") ||
             strstr(hashtags, "travel")) {
        strcpy(result.category, "여행");
    }
    else if (strstr(caption, "운동") ||
             strstr(hashtags, "운동") ||
             strstr(caption, "헬스") ||
             strstr(hashtags, "헬스") ||
             strstr(caption, "fitness") ||
             strstr(hashtags, "fitness")) {
        strcpy(result.category, "운동");
    }
    else if (strstr(caption, "패션") ||
             strstr(hashtags, "패션") ||
             strstr(caption, "코디") ||
             strstr(hashtags, "ootd") ||
             strstr(caption, "옷")) {
        strcpy(result.category, "패션");
    }
    else if (strstr(caption, "뷰티") ||
             strstr(hashtags, "뷰티") ||
             strstr(caption, "메이크업") ||
             strstr(hashtags, "메이크업") ||
             strstr(caption, "화장")) {
        strcpy(result.category, "뷰티");
    }
    else if (strstr(caption, "강아지") ||
             strstr(hashtags, "강아지") ||
             strstr(caption, "고양이") ||
             strstr(hashtags, "반려동물") ||
             strstr(caption, "펫")) {
        strcpy(result.category, "반려동물");
    }
    else if (strstr(caption, "인테리어") ||
             strstr(hashtags, "인테리어") ||
             strstr(caption, "홈데코") ||
             strstr(hashtags, "홈데코")) {
        strcpy(result.category, "인테리어");
    }
    else if (strstr(caption, "독서") ||
             strstr(hashtags, "독서") ||
             strstr(caption, "책") ||
             strstr(hashtags, "북스타그램")) {
        strcpy(result.category, "독서");
    }
    else {
        strcpy(result.category, "기타");
        result.confidence = 0.5f;
    }

    char msg[100];
    sprintf(msg, "분류 결과: %s (%.0f%%)",
            result.category,
            result.confidence * 100);
    LOG_INFO(msg);

    return result;
}

void update_feedback(const char* keyword,
                     const char* correct_category) {
    char msg[200];
    sprintf(msg, "피드백 반영: %s → %s",
            keyword, correct_category);
    LOG_INFO(msg);
    printf("피드백 반영: %s → %s\n",
           keyword, correct_category);
}