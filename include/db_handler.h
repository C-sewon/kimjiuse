#ifndef DB_HANDLER_H
#define DB_HANDLER_H

int db_init(const char* db_path);

int db_insert(const char* post_id,
              const char* category,
              float confidence);

int db_update_category(const char* post_id,
                       const char* new_category);

char** db_query_by_category(const char* category,
                             int* result_count);

void db_close(void);

#endif