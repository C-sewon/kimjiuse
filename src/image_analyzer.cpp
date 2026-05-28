#include "image_analyzer.h"
#include "logger.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

ImageLabels analyze_image(const char* image_path) {
    ImageLabels result;

    if (image_path == NULL) {
        LOG_ERROR("이미지 경로가 없습니다");
        result.count = 0;
        return result;
    }

    char msg[200];
    sprintf(msg, "이미지 분석 중: %s", image_path);
    LOG_INFO(msg);

    // 임시버전 - 추후 OpenCV로 교체 예정
    result.count = 3;
    strcpy(result.labels[0], "food");
    strcpy(result.labels[1], "person");
    strcpy(result.labels[2], "table");

    sprintf(msg, "분석 완료: %d개 레이블 추출",
            result.count);
    LOG_INFO(msg);

    return result;
}

void print_labels(ImageLabels labels) {
    LOG_INFO("레이블 목록 출력");
    printf("추출된 레이블:\n");
    for (int i = 0; i < labels.count; i++) {
        printf("  [%d] %s\n",
               i+1, labels.labels[i]);
    }
}