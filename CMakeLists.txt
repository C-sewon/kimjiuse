cmake_minimum_required(VERSION 3.15)
project(BookmarkClassifier)

set(CMAKE_CXX_STANDARD 17)

# 소스 파일 목록
add_executable(classifier
    src/main.cpp
    src/text_classifier.cpp
    src/image_analyzer.cpp
    src/feedback_engine.cpp
    src/db_handler.c
)

# 헤더 파일 위치
target_include_directories(classifier PRIVATE include)