#include "text_classifier.h"
#include <assert.h>
#include <stdio.h>
#include <cstring>
#include <string.h>

void test_food_category() {
    ClassifyResult r = classify_text(
        "오늘 점심 맛있었다",
        "#맛집 #점심");
    assert(strcmp(r.category, "맛집") == 0);
    printf("✅ 맛집 테스트 통과\n");
}

void test_travel_category() {
    ClassifyResult r = classify_text(
        "제주도 여행 다녀왔어요",
        "#여행 #제주도");
    assert(strcmp(r.category, "여행") == 0);
    printf("✅ 여행 테스트 통과\n");
}

void test_dev_category() {
    ClassifyResult r = classify_text(
        "코딩 재밌다",
        "#개발 #coding");
    assert(strcmp(r.category, "개발") == 0);
    printf("✅ 개발 테스트 통과\n");
}

void test_null_input() {
    ClassifyResult r = classify_text(
        NULL, NULL);
    assert(strcmp(r.category, "기타") == 0);
    printf("✅ NULL 입력 테스트 통과\n");
}

void test_confidence_range() {
    ClassifyResult r = classify_text(
        "맛집 카페 점심",
        "#맛집 #카페");
    assert(r.confidence >= 0.0f &&
           r.confidence <= 1.0f);
    printf("✅ 신뢰도 범위 테스트 통과\n");
}

int main() {
    printf("=== Unit Test 시작 ===\n");
    test_food_category();
    test_travel_category();
    test_dev_category();
    test_null_input();
    test_confidence_range();
    printf("=== 모든 테스트 통과 ===\n");
    return 0;
}