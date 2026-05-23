#ifndef LOGGER_H
#define LOGGER_H

#include <stdio.h>
#include <time.h>

typedef enum {
    LOG_INFO,
    LOG_WARNING,
    LOG_ERROR
} LogLevel;

static FILE* log_file = NULL;

// Logger 초기화
static void logger_init(const char* filepath) {
    log_file = fopen(filepath, "a");
    if (log_file == NULL) {
        printf("Logger 초기화 실패\n");
    }
}

// 로그 출력
static void log_message(LogLevel level,
                         const char* message) {
    // 현재 시간
    time_t now = time(NULL);
    struct tm* t = localtime(&now);
    char time_str[20];
    strftime(time_str, sizeof(time_str),
             "%Y-%m-%d %H:%M:%S", t);

    // 레벨 문자열
    const char* level_str;
    switch(level) {
        case LOG_INFO:    level_str = "INFO";    break;
        case LOG_WARNING: level_str = "WARNING"; break;
        case LOG_ERROR:   level_str = "ERROR";   break;
        default:          level_str = "INFO";    break;
    }

    // 화면 출력
    printf("[%s] [%s] %s\n",
           time_str, level_str, message);

    // 파일 저장
    if (log_file != NULL) {
        fprintf(log_file, "[%s] [%s] %s\n",
                time_str, level_str, message);
        fflush(log_file);
    }
}

// Logger 종료
static void logger_close() {
    if (log_file != NULL) {
        fclose(log_file);
        log_file = NULL;
    }
}

// 편의 매크로
#define LOG_INFO(msg)    log_message(LOG_INFO, msg)
#define LOG_WARN(msg)    log_message(LOG_WARNING, msg)
#define LOG_ERROR(msg)   log_message(LOG_ERROR, msg)

#endif