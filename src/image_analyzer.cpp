#include "image_analyzer.h"
#include <string.h>
#include <stdio.h>

ImageLabels analyze_image(const char* image_path) {
    ImageLabels result;
    result.count = 3;

    // 임시버전 - 샘플 레이블 반환
    strcpy(result.labels[0], "food");
    strcpy(result.labels[1], "person");
    strcpy(result.labels[2], "table");

    printf("이미지 분석: %s\n", image_path);
    return result;
}