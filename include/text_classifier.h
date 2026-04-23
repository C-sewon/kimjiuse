#ifndef TEXT_CLASSIFIER_H
#define TEXT_CLASSIFIER_H

// 분류 결과를 담는 구조체
typedef struct {
    char category[50];   // "맛집", "개발", "여행" 등
    float confidence;    // 확신도 0.0 ~ 1.0
} ClassifyResult;

// 텍스트 분류 함수
// caption: 게시물 캡션
// hashtags: 해시태그 문자열
ClassifyResult classify_text(const char* caption,
                              const char* hashtags);

// 피드백 반영 함수
// keyword: 해당 키워드
// correct_category: 올바른 카테고리
void update_feedback(const char* keyword,
                     const char* correct_category);

#endif