#include "text_classifier.h"
#include <string.h>
#include <stdio.h>

ClassifyResult classify_text(const char* caption,
                              const char* hashtags) {
    ClassifyResult result;
    result.confidence = 0.9f;

    // 맛집
    if (strstr(caption, "맛집") ||
        strstr(hashtags, "맛집") ||
        strstr(caption, "점심") ||
        strstr(caption, "카페") ||
        strstr(caption, "커피") ||
        strstr(caption, "food") ||
        strstr(hashtags, "food")) {
        strcpy(result.category, "맛집");
    }
    // 개발
    else if (strstr(caption, "개발") ||
             strstr(hashtags, "개발") ||
             strstr(caption, "코딩") ||
             strstr(caption, "coding") ||
             strstr(hashtags, "coding") ||
             strstr(hashtags, "github")) {
        strcpy(result.category, "개발");
    }
    // 여행
    else if (strstr(caption, "여행") ||
             strstr(hashtags, "여행") ||
             strstr(caption, "제주도") ||
             strstr(caption, "바다") ||
             strstr(caption, "travel") ||
             strstr(hashtags, "travel")) {
        strcpy(result.category, "여행");
    }
    // 운동
    else if (strstr(caption, "운동") ||
             strstr(hashtags, "운동") ||
             strstr(caption, "헬스") ||
             strstr(hashtags, "헬스") ||
             strstr(caption, "fitness") ||
             strstr(hashtags, "fitness")) {
        strcpy(result.category, "운동");
    }
    // 패션 (새로 추가)
    else if (strstr(caption, "패션") ||
             strstr(hashtags, "패션") ||
             strstr(caption, "코디") ||
             strstr(hashtags, "ootd") ||
             strstr(caption, "옷") ||
             strstr(hashtags, "코디")) {
        strcpy(result.category, "패션");
    }
    // 뷰티 (새로 추가)
    else if (strstr(caption, "뷰티") ||
             strstr(hashtags, "뷰티") ||
             strstr(caption, "메이크업") ||
             strstr(hashtags, "메이크업") ||
             strstr(caption, "화장") ||
             strstr(hashtags, "makeup")) {
        strcpy(result.category, "뷰티");
    }
    // 반려동물 (새로 추가)
    else if (strstr(caption, "강아지") ||
             strstr(hashtags, "강아지") ||
             strstr(caption, "고양이") ||
             strstr(hashtags, "반려동물") ||
             strstr(caption, "펫") ||
             strstr(hashtags, "펫")) {
        strcpy(result.category, "반려동물");
    }
    // 인테리어 (새로 추가)
    else if (strstr(caption, "인테리어") ||
             strstr(hashtags, "인테리어") ||
             strstr(caption, "홈데코") ||
             strstr(hashtags, "홈데코") ||
             strstr(caption, "집꾸미기")) {
        strcpy(result.category, "인테리어");
    }
    // 독서 (새로 추가)
    else if (strstr(caption, "독서") ||
             strstr(hashtags, "독서") ||
             strstr(caption, "책") ||
             strstr(hashtags, "북스타그램")) {
        strcpy(result.category, "독서");
    }
    // 기타
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