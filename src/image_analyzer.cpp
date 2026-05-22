#include "image_analyzer.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

ImageLabels analyze_image(const char* image_path) {
    ImageLabels result;

    // 경로 유효성 검사
    if (image_path == NULL) {
        printf("오류: 이미지 경로가 없습니다\n");
        result.count = 0;
        return result;
    }

    printf("이미지 분석 중: %s\n", image_path);

    // 임시버전 - 샘플 레이블 반환
    // 추후 OpenCV + MobileNet으로 교체 예정
    result.count = 3;
    strcpy(result.labels[0], "food");
    strcpy(result.labels[1], "person");
    strcpy(result.labels[2], "table");

    printf("분석 완료: %d개 레이블 추출\n",
           result.count);

    return result;
}

// 레이블 출력 함수 추가
void print_labels(ImageLabels labels) {
    printf("추출된 레이블:\n");
    for (int i = 0; i < labels.count; i++) {
        printf("  [%d] %s\n", i+1, labels.labels[i]);
    }
}