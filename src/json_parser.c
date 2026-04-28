#include "json_parser.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

Bookmark* load_bookmarks(const char* filepath,
                          int* count) {
    // 파일 경로 유효성 검사
    if (filepath == NULL) {
        printf("오류: 파일 경로가 없습니다\n");
        *count = 0;
        return NULL;
    }

    *count = 10;
    Bookmark* bookmarks = malloc(
        sizeof(Bookmark) * (*count));

    // 메모리 할당 실패 처리
    if (bookmarks == NULL) {
        printf("오류: 메모리 할당 실패\n");
        *count = 0;
        return NULL;
    }

    strcpy(bookmarks[0].post_id, "post_001");
    strcpy(bookmarks[0].caption,
           "오늘 점심 너무 맛있었다 강남 맛집");
    strcpy(bookmarks[0].hashtags,
           "#맛집 #점심 #강남");
    strcpy(bookmarks[0].image_path,
           "data/images/post_001.jpg");

    strcpy(bookmarks[1].post_id, "post_002");
    strcpy(bookmarks[1].caption,
           "코딩 재밌다 깃허브 잔디심기");
    strcpy(bookmarks[1].hashtags,
           "#개발 #coding #github");
    strcpy(bookmarks[1].image_path,
           "data/images/post_002.jpg");

    strcpy(bookmarks[2].post_id, "post_003");
    strcpy(bookmarks[2].caption,
           "제주도 여행 너무 좋았다 바다");
    strcpy(bookmarks[2].hashtags,
           "#여행 #제주도 #바다");
    strcpy(bookmarks[2].image_path,
           "data/images/post_003.jpg");

    strcpy(bookmarks[3].post_id, "post_004");
    strcpy(bookmarks[3].caption,
           "헬스장 운동 완료 벤치프레스 신기록");
    strcpy(bookmarks[3].hashtags,
           "#운동 #헬스 #fitness");
    strcpy(bookmarks[3].image_path,
           "data/images/post_004.jpg");

    strcpy(bookmarks[4].post_id, "post_005");
    strcpy(bookmarks[4].caption,
           "오늘 코디 너무 마음에 들어 봄 신상");
    strcpy(bookmarks[4].hashtags,
           "#패션 #ootd #코디");
    strcpy(bookmarks[4].image_path,
           "data/images/post_005.jpg");

    strcpy(bookmarks[5].post_id, "post_006");
    strcpy(bookmarks[5].caption,
           "오늘 카페 분위기 너무 좋다 커피 맛집");
    strcpy(bookmarks[5].hashtags,
           "#카페 #커피 #맛집");
    strcpy(bookmarks[5].image_path,
           "data/images/post_006.jpg");

    strcpy(bookmarks[6].post_id, "post_007");
    strcpy(bookmarks[6].caption,
           "강아지 너무 귀여워 산책 다녀왔어");
    strcpy(bookmarks[6].hashtags,
           "#반려동물 #강아지 #펫");
    strcpy(bookmarks[6].image_path,
           "data/images/post_007.jpg");

    strcpy(bookmarks[7].post_id, "post_008");
    strcpy(bookmarks[7].caption,
           "오늘 메이크업 따라해봤어 뷰티 유튜버");
    strcpy(bookmarks[7].hashtags,
           "#뷰티 #메이크업 #화장");
    strcpy(bookmarks[7].image_path,
           "data/images/post_008.jpg");

    strcpy(bookmarks[8].post_id, "post_009");
    strcpy(bookmarks[8].caption,
           "인테리어 바꿨는데 너무 예쁘다 홈데코");
    strcpy(bookmarks[8].hashtags,
           "#인테리어 #홈데코 #집꾸미기");
    strcpy(bookmarks[8].image_path,
           "data/images/post_009.jpg");

    strcpy(bookmarks[9].post_id, "post_010");
    strcpy(bookmarks[9].caption,
           "오늘 독서 완료 책 추천해줘");
    strcpy(bookmarks[9].hashtags,
           "#독서 #책 #북스타그램");
    strcpy(bookmarks[9].image_path,
           "data/images/post_010.jpg");

    printf("북마크 %d개 로드 완료\n", *count);
    return bookmarks;
}

void free_bookmarks(Bookmark* bookmarks) {
    if (bookmarks != NULL) {
        free(bookmarks);
    }
}

