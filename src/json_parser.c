#include "json_parser.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

Bookmark* load_bookmarks(const char* filepath,
                          int* count) {
    *count = 4;
    Bookmark* bookmarks = malloc(sizeof(Bookmark) * 4);

    strcpy(bookmarks[0].post_id, "post_001");
    strcpy(bookmarks[0].caption,
           "오늘 점심 너무 맛있었다 강남 맛집");
    strcpy(bookmarks[0].hashtags, "#맛집 #점심 #강남");
    strcpy(bookmarks[0].image_path,
           "data/images/post_001.jpg");

    strcpy(bookmarks[1].post_id, "post_002");
    strcpy(bookmarks[1].caption,
           "코딩 재밌다 깃허브 잔디심기");
    strcpy(bookmarks[1].hashtags, "#개발 #coding #github");
    strcpy(bookmarks[1].image_path,
           "data/images/post_002.jpg");

    strcpy(bookmarks[2].post_id, "post_003");
    strcpy(bookmarks[2].caption,
           "제주도 여행 너무 좋았다 바다");
    strcpy(bookmarks[2].hashtags, "#여행 #제주도 #바다");
    strcpy(bookmarks[2].image_path,
           "data/images/post_003.jpg");

    strcpy(bookmarks[3].post_id, "post_004");
    strcpy(bookmarks[3].caption,
           "헬스장 운동 완료 벤치프레스 신기록");
    strcpy(bookmarks[3].hashtags, "#운동 #헬스 #fitness");
    strcpy(bookmarks[3].image_path,
           "data/images/post_004.jpg");

    printf("북마크 %d개 로드 완료\n", *count);
    return bookmarks;
}

void free_bookmarks(Bookmark* bookmarks) {
    free(bookmarks);
}