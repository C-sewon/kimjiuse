cmake_minimum_required(VERSION 3.15)
project(BookmarkClassifier)

set(CMAKE_CXX_STANDARD 17)

set(CMAKE_CXX_FLAGS
    "${CMAKE_CXX_FLAGS} --coverage")
set(CMAKE_C_FLAGS
    "${CMAKE_C_FLAGS} --coverage")

# SQLite include 경로
include_directories(
    include
    C:/vcpkg/installed/x64-windows/include
)

# exe 빌드 (테스트용)
add_executable(classifier
    src/main.cpp
    src/db_handler.cpp
    src/json_parser.c
    src/text_classifier.cpp
    src/image_analyzer.cpp
    src/feedback_engine.cpp
)

target_link_libraries(classifier
    C:/vcpkg/installed/x64-windows/lib/sqlite3.lib)

# dll 빌드 (Flutter FFI용)
add_library(classifier_lib SHARED
    src/classifier_api.cpp
    src/db_handler.cpp
    src/json_parser.c
    src/text_classifier.cpp
    src/image_analyzer.cpp
    src/feedback_engine.cpp
)

target_link_libraries(classifier_lib
    C:/vcpkg/installed/x64-windows/lib/sqlite3.lib)

    # 테스트 실행파일 추가
add_executable(test_classifier
    src/test_classifier.cpp
    src/text_classifier.cpp
    src/feedback_engine.cpp
)

target_include_directories(test_classifier
    PRIVATE include
    C:/vcpkg/installed/x64-windows/include
)

target_link_libraries(test_classifier
    C:/vcpkg/installed/x64-windows/lib/sqlite3.lib
)