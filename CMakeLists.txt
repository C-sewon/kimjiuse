cmake_minimum_required(VERSION 3.15)
project(BookmarkClassifier)

set(CMAKE_CXX_STANDARD 17)

add_executable(classifier
    src/main.cpp
    src/db_handler.cpp
    src/json_parser.c
    src/text_classifier.cpp
    src/image_analyzer.cpp
    src/feedback_engine.cpp
)

target_include_directories(classifier PRIVATE 
    include
    C:/vcpkg/installed/x64-windows/include
)

target_link_libraries(classifier
    C:/vcpkg/installed/x64-windows/lib/sqlite3.lib
)