#include "text_classifier.h"
#include "logger.h"
#include <string.h>
#include <stdio.h>
#include <ctype.h>

static void to_lower(const char* src, char* dst, int size) {
    int i;
    for (i = 0; i < size - 1 && src[i]; i++)
        dst[i] = tolower((unsigned char)src[i]);
    dst[i] = '\0';
}

ClassifyResult classify_text(const char* caption,
                              const char* hashtags) {
    LOG_INFO("텍스트 분류 시작");

    if (caption == NULL) caption = "";
    if (hashtags == NULL) hashtags = "";

    char low_caption[500];
    char low_hashtags[500];
    to_lower(caption, low_caption, 500);
    to_lower(hashtags, low_hashtags, 500);

    ClassifyResult result;
    result.confidence = 0.7f;

    if (strstr(low_caption, "맛집") ||
        strstr(low_hashtags, "맛집") ||
        strstr(low_caption, "점심") ||
        strstr(low_caption, "카페") ||
        strstr(low_caption, "커피") ||
        strstr(low_caption, "food") ||
        strstr(low_hashtags, "food") ||
        strstr(low_caption, "레스토랑") ||
        strstr(low_caption, "브런치") ||
        strstr(low_caption, "디저트")) {
        strcpy(result.category, "맛집");

        int match_count = 0;
        if (strstr(low_caption, "맛집")) match_count++;
        if (strstr(low_hashtags, "맛집")) match_count++;
        if (strstr(low_caption, "카페")) match_count++;
        if (strstr(low_hashtags, "카페")) match_count++;
        if (strstr(low_caption, "점심")) match_count++;
        result.confidence = 0.7f + (match_count * 0.1f);
        if (result.confidence > 1.0f) result.confidence = 1.0f;
    }
    else if (strstr(low_caption, "개발") ||
             strstr(low_hashtags, "개발") ||
             strstr(low_caption, "코딩") ||
             strstr(low_caption, "coding") ||
             strstr(low_hashtags, "coding") ||
             strstr(low_hashtags, "github") ||
             strstr(low_caption, "프로그래밍") ||
             strstr(low_hashtags, "개발자")) {
        strcpy(result.category, "개발");

        int match_count = 0;
        if (strstr(low_caption, "개발")) match_count++;
        if (strstr(low_hashtags, "개발")) match_count++;
        if (strstr(low_caption, "코딩")) match_count++;
        result.confidence = 0.7f + (match_count * 0.1f);
        if (result.confidence > 1.0f) result.confidence = 1.0f;
    }
    else if (strstr(low_caption, "여행") ||
             strstr(low_hashtags, "여행") ||
             strstr(low_caption, "제주도") ||
             strstr(low_caption, "바다") ||
             strstr(low_caption, "travel") ||
             strstr(low_hashtags, "travel") ||
             strstr(low_caption, "해외") ||
             strstr(low_hashtags, "국내여행")) {
        strcpy(result.category, "여행");

        int match_count = 0;
        if (strstr(low_caption, "여행")) match_count++;
        if (strstr(low_hashtags, "여행")) match_count++;
        if (strstr(low_caption, "제주도")) match_count++;
        result.confidence = 0.7f + (match_count * 0.1f);
        if (result.confidence > 1.0f) result.confidence = 1.0f;
    }
    else if (strstr(low_caption, "운동") ||
             strstr(low_hashtags, "운동") ||
             strstr(low_caption, "헬스") ||
             strstr(low_hashtags, "헬스") ||
             strstr(low_caption, "fitness") ||
             strstr(low_hashtags, "fitness") ||
             strstr(low_caption, "다이어트") ||
             strstr(low_hashtags, "workout")) {
        strcpy(result.category, "운동");

        int match_count = 0;
        if (strstr(low_caption, "운동")) match_count++;
        if (strstr(low_hashtags, "운동")) match_count++;
        if (strstr(low_caption, "헬스")) match_count++;
        result.confidence = 0.7f + (match_count * 0.1f);
        if (result.confidence > 1.0f) result.confidence = 1.0f;
    }
    else if (strstr(low_caption, "패션") ||
             strstr(low_hashtags, "패션") ||
             strstr(low_caption, "코디") ||
             strstr(low_hashtags, "ootd") ||
             strstr(low_caption, "옷") ||
             strstr(low_hashtags, "스타일") ||
             strstr(low_caption, "fashion")) {
        strcpy(result.category, "패션");

        int match_count = 0;
        if (strstr(low_caption, "패션")) match_count++;
        if (strstr(low_hashtags, "패션")) match_count++;
        if (strstr(low_hashtags, "ootd")) match_count++;
        result.confidence = 0.7f + (match_count * 0.1f);
        if (result.confidence > 1.0f) result.confidence = 1.0f;
    }
    else if (strstr(low_caption, "뷰티") ||
             strstr(low_hashtags, "뷰티") ||
             strstr(low_caption, "메이크업") ||
             strstr(low_hashtags, "메이크업") ||
             strstr(low_caption, "화장") ||
             strstr(low_hashtags, "makeup") ||
             strstr(low_caption, "스킨케어")) {
        strcpy(result.category, "뷰티");

        int match_count = 0;
        if (strstr(low_caption, "뷰티")) match_count++;
        if (strstr(low_hashtags, "뷰티")) match_count++;
        if (strstr(low_caption, "메이크업")) match_count++;
        result.confidence = 0.7f + (match_count * 0.1f);
        if (result.confidence > 1.0f) result.confidence = 1.0f;
    }
    else if (strstr(low_caption, "강아지") ||
             strstr(low_hashtags, "강아지") ||
             strstr(low_caption, "고양이") ||
             strstr(low_hashtags, "반려동물") ||
             strstr(low_caption, "펫") ||
             strstr(low_hashtags, "댕댕이") ||
             strstr(low_hashtags, "냥이")) {
        strcpy(result.category, "반려동물");

        int match_count = 0;
        if (strstr(low_caption, "강아지")) match_count++;
        if (strstr(low_hashtags, "강아지")) match_count++;
        if (strstr(low_caption, "고양이")) match_count++;
        result.confidence = 0.7f + (match_count * 0.1f);
        if (result.confidence > 1.0f) result.confidence = 1.0f;
    }
    else if (strstr(low_caption, "인테리어") ||
             strstr(low_hashtags, "인테리어") ||
             strstr(low_caption, "홈데코") ||
             strstr(low_hashtags, "홈데코") ||
             strstr(low_caption, "집꾸미기") ||
             strstr(low_hashtags, "인테리어소품")) {
        strcpy(result.category, "인테리어");

        int match_count = 0;
        if (strstr(low_caption, "인테리어")) match_count++;
        if (strstr(low_hashtags, "인테리어")) match_count++;
        if (strstr(low_caption, "홈데코")) match_count++;
        result.confidence = 0.7f + (match_count * 0.1f);
        if (result.confidence > 1.0f) result.confidence = 1.0f;
    }
    else if (strstr(low_caption, "독서") ||
             strstr(low_hashtags, "독서") ||
             strstr(low_caption, "책") ||
             strstr(low_hashtags, "북스타그램") ||
             strstr(low_hashtags, "책스타그램") ||
             strstr(low_caption, "reading")) {
        strcpy(result.category, "독서");

        int match_count = 0;
        if (strstr(low_caption, "독서")) match_count++;
        if (strstr(low_hashtags, "독서")) match_count++;
        if (strstr(low_caption, "책")) match_count++;
        result.confidence = 0.7f + (match_count * 0.1f);
        if (result.confidence > 1.0f) result.confidence = 1.0f;
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