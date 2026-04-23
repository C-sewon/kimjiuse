#ifndef IMAGE_ANALYZER_H
#define IMAGE_ANALYZER_H

// 이미지에서 추출한 레이블 목록
// 최대 10개
typedef struct {
    char labels[10][50];  // ["food", "person", ...]
    int count;            // 실제 추출된 개수
} ImageLabels;

// 이미지 분석 함수
// image_path: 이미지 파일 경로
ImageLabels analyze_image(const char* image_path);

#endif