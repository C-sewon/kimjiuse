#include "feedback_engine.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// 가중치 테이블
// 키워드별로 카테고리 점수 저장
typedef struct {
    char keyword[50];
    char category[50];
    float weight;
} WeightEntry;

// 최대 100개 가중치 저장
static WeightEntry weights[100];
static int weight_count = 0;

void feedback_init() {
    weight_count = 0;
    printf("피드백 엔진 초기화 완료\n");
}

void update_weight(const char* keyword,
                   const char* correct_category,
                   float delta) {
    // 기존 가중치 찾기
    for (int i = 0; i < weight_count; i++) {
        if (strcmp(weights[i].keyword, keyword) == 0 &&
            strcmp(weights[i].category,
                   correct_category) == 0) {
            weights[i].weight += delta;
            printf("가중치 업데이트: %s → %s (%.2f)\n",
                   keyword, correct_category,
                   weights[i].weight);
            return;
        }
    }

    // 새 가중치 추가
    if (weight_count < 100) {
        strcpy(weights[weight_count].keyword, keyword);
        strcpy(weights[weight_count].category,
               correct_category);
        weights[weight_count].weight = delta;
        weight_count++;
        printf("새 가중치 추가: %s → %s\n",
               keyword, correct_category);
    }
}

float get_weight(const char* keyword,
                 const char* category) {
    for (int i = 0; i < weight_count; i++) {
        if (strcmp(weights[i].keyword, keyword) == 0 &&
            strcmp(weights[i].category, category) == 0) {
            return weights[i].weight;
        }
    }
    return 0.0f;
}

void save_weights(const char* filepath) {
    FILE* f = fopen(filepath, "w");
    if (f == NULL) {
        printf("오류: 파일 저장 실패\n");
        return;
    }

    for (int i = 0; i < weight_count; i++) {
        fprintf(f, "%s,%s,%.4f\n",
                weights[i].keyword,
                weights[i].category,
                weights[i].weight);
    }

    fclose(f);
    printf("가중치 저장 완료: %s\n", filepath);
}

void load_weights(const char* filepath) {
    FILE* f = fopen(filepath, "r");
    if (f == NULL) {
        printf("가중치 파일 없음: 새로 시작\n");
        return;
    }

    weight_count = 0;
    while (fscanf(f, "%49[^,],%49[^,],%f\n",
                  weights[weight_count].keyword,
                  weights[weight_count].category,
                  &weights[weight_count].weight) == 3) {
        weight_count++;
        if (weight_count >= 100) break;
    }

    fclose(f);
    printf("가중치 로드 완료: %d개\n", weight_count);
}