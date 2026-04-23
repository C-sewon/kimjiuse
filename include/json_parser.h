#ifndef JSON_PARSER_H
#define JSON_PARSER_H

typedef struct {
    char post_id[50];
    char caption[500];
    char hashtags[200];
    char image_path[200];
} Bookmark;

#ifdef __cplusplus
extern "C" {
#endif

Bookmark* load_bookmarks(const char* filepath, int* count);
void free_bookmarks(Bookmark* bookmarks);

#ifdef __cplusplus
}
#endif

#endif