#include "text_classifier.h"
#include "logger.h"
#include <string.h>
#include <stdio.h>

ClassifyResult classify_text(const char* caption,
                              const char* hashtags) {
    LOG_INFO("텍스트 분류 시작");

    // NULL 체크
    if (caption == NULL) caption = "";
    if (hashtags == NULL) hashtags = "";

    ClassifyResult result;
    result.confidence = 0.7f;

    if (strstr(caption, "맛집") ||
        strstr(hashtags, "맛집") ||
        strstr(caption, "점심") ||
        strstr(caption, "카페") ||
        strstr(caption, "커피") ||
        strstr(caption, "food") ||
        strstr(hashtags, "food") ||
        strstr(caption, "레스토랑") ||
        strstr(caption, "브런치") ||
        strstr(caption, "디저트")) {
        strcpy(result.category, "맛집");

        // 키워드 개수별 신뢰도
        int match_count = 0;
        if (strstr(caption, "맛집")) match_count++;
        if (strstr(hashtags, "맛집")) match_count++;
        if (strstr(caption, "카페")) match_count++;
        if (strstr(hashtags, "카페")) match_count++;
        if (strstr(caption, "점심")) match_count++;
        result.confidence = 0.7f +
            (match_count * 0.1f);
        if (result.confidence > 1.0f)
            result.confidence = 1.0f;
    }
    else if (strstr(caption, "개발") ||
             strstr(hashtags, "개발") ||
             strstr(caption, "코딩") ||
             strstr(caption, "coding") ||
             strstr(hashtags, "coding") ||
             strstr(hashtags, "github") ||
             strstr(caption, "프로그래밍") ||
             strstr(hashtags, "개발자")) {
        strcpy(result.category, "개발");

        int match_count = 0;
        if (strstr(caption, "개발")) match_count++;
        if (strstr(hashtags, "개발")) match_count++;
        if (strstr(caption, "코딩")) match_count++;
        result.confidence = 0.7f +
            (match_count * 0.1f);
        if (result.confidence > 1.0f)
            result.confidence = 1.0f;
    }
    else if (strstr(caption, "여행") ||
             strstr(hashtags, "여행") ||
             strstr(caption, "제주도") ||
             strstr(caption, "바다") ||
             strstr(caption, "travel") ||
             strstr(hashtags, "travel") ||
             strstr(caption, "해외") ||
             strstr(hashtags, "국내여행")) {
        strcpy(result.category, "여행");

        int match_count = 0;
        if (strstr(caption, "여행")) match_count++;
        if (strstr(hashtags, "여행")) match_count++;
        if (strstr(caption, "제주도")) match_count++;
        result.confidence = 0.7f +
            (match_count * 0.1f);
        if (result.confidence > 1.0f)
            result.confidence = 1.0f;
    }
    else if (strstr(caption, "운동") ||
             strstr(hashtags, "운동") ||
             strstr(caption, "헬스") ||
             strstr(hashtags, "헬스") ||
             strstr(caption, "fitness") ||
             strstr(hashtags, "fitness") ||
             strstr(caption, "다이어트") ||
             strstr(hashtags, "workout")) {
        strcpy(result.category, "운동");

        int match_count = 0;
        if (strstr(caption, "운동")) match_count++;
        if (strstr(hashtags, "운동")) match_count++;
        if (strstr(caption, "헬스")) match_count++;
        result.confidence = 0.7f +
            (match_count * 0.1f);
        if (result.confidence > 1.0f)
            result.confidence = 1.0f;
    }
    else if (strstr(caption, "패션") ||
             strstr(hashtags, "패션") ||
             strstr(caption, "코디") ||
             strstr(hashtags, "ootd") ||
             strstr(caption, "옷") ||
             strstr(hashtags, "스타일") ||
             strstr(caption, "fashion")) {
        strcpy(result.category, "패션");

        int match_count = 0;
        if (strstr(caption, "패션")) match_count++;
        if (strstr(hashtags, "패션")) match_count++;
        if (strstr(hashtags, "ootd")) match_count++;
        result.confidence = 0.7f +
            (match_count * 0.1f);
        if (result.confidence > 1.0f)
            result.confidence = 1.0f;
    }
    else if (strstr(caption, "뷰티") ||
             strstr(hashtags, "뷰티") ||
             strstr(caption, "메이크업") ||
             strstr(hashtags, "메이크업") ||
             strstr(caption, "화장") ||
             strstr(hashtags, "makeup") ||
             strstr(caption, "스킨케어")) {
        strcpy(result.category, "뷰티");

        int match_count = 0;
        if (strstr(caption, "뷰티")) match_count++;
        if (strstr(hashtags, "뷰티")) match_count++;
        if (strstr(caption, "메이크업")) match_count++;
        result.confidence = 0.7f +
            (match_count * 0.1f);
        if (result.confidence > 1.0f)
            result.confidence = 1.0f;
    }
    else if (strstr(caption, "강아지") ||
             strstr(hashtags, "강아지") ||
             strstr(caption, "고양이") ||
             strstr(hashtags, "반려동물") ||
             strstr(caption, "펫") ||
             strstr(hashtags, "댕댕이") ||
             strstr(hashtags, "냥이")) {
        strcpy(result.category, "반려동물");

        int match_count = 0;
        if (strstr(caption, "강아지")) match_count++;
        if (strstr(hashtags, "강아지")) match_count++;
        if (strstr(caption, "고양이")) match_count++;
        result.confidence = 0.7f +
            (match_count * 0.1f);
        if (result.confidence > 1.0f)
            result.confidence = 1.0f;
    }
    else if (strstr(caption, "인테리어") ||
             strstr(hashtags, "인테리어") ||
             strstr(caption, "홈데코") ||
             strstr(hashtags, "홈데코") ||
             strstr(caption, "집꾸미기") ||
             strstr(hashtags, "인테리어소품")) {
        strcpy(result.category, "인테리어");

        int match_count = 0;
        if (strstr(caption, "인테리어")) match_count++;
        if (strstr(hashtags, "인테리어")) match_count++;
        if (strstr(caption, "홈데코")) match_count++;
        result.confidence = 0.7f +
            (match_count * 0.1f);
        if (result.confidence > 1.0f)
            result.confidence = 1.0f;
    }
    else if (strstr(caption, "독서") ||
             strstr(hashtags, "독서") ||
             strstr(caption, "책") ||
             strstr(hashtags, "북스타그램") ||
             strstr(hashtags, "책스타그램") ||
             strstr(caption, "reading")) {
        strcpy(result.category, "독서");

        int match_count = 0;
        if (strstr(caption, "독서")) match_count++;
        if (strstr(hashtags, "독서")) match_count++;
        if (strstr(caption, "책")) match_count++;
        result.confidence = 0.7f +
            (match_count * 0.1f);
        if (result.confidence > 1.0f)
            result.confidence = 1.0f;
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