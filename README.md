# 📌 인스타그램 북마크 자동분류 AI

인스타그램 게시물 URL을 입력하면
AI가 자동으로 카테고리를 분류해서
저장해주는 앱입니다.

## 🛠️ 기술 스택

| 분류 | 기술 |
|------|------|
| 분류 엔진 | C++17 |
| 이미지 분석 | OpenCV |
| DB | SQLite3 |
| 앱 UI | Flutter |
| 데이터 수집 | Python + Instaloader |
| API 서버 | FastAPI |
| 빌드 | CMake |
| 협업 | Git / GitHub |

## 👥 팀원 역할

| 역할 | 담당 |
|------|------|
| 팀장 | 통합, DB, FFI, Git 관리 |
| 팀원A | 데이터 수집, FastAPI 서버 |
| 팀원B | 텍스트 분류 엔진 |
| 팀원C | 이미지 분석, Flutter UI |

## 🚀 실행 방법

### 1. Python 서버 실행
```bash
cd collector
uvicorn server:app --reload --port 8000
```

### 2. C++ 빌드
```bash
mkdir build
cd build
cmake .. -G "MinGW Makefiles"
cmake --build .
```

### 3. Flutter 앱 실행
```bash
cd flutter_app
flutter run -d windows
```

## 📁 프로젝트 구조
bookmark-classifier/
├── src/                  # C++ 소스
│   ├── main.cpp
│   ├── db_handler.cpp
│   ├── text_classifier.cpp
│   ├── image_analyzer.cpp
│   ├── json_parser.c
│   ├── feedback_engine.cpp
│   └── classifier_api.cpp
├── include/              # 헤더파일
├── collector/            # Python 수집기
│   ├── collector.py
│   └── server.py
├── flutter_app/          # Flutter UI
├── data/                 # 데이터
└── models/               # AI 모델

## 🔄 시스템 흐름
URL 입력 (Flutter)
↓
Python 서버 (데이터 수집)
↓
C++ 엔진 (텍스트 + 이미지 분류)
↓
SQLite DB (저장)
↓
Flutter UI (결과 표시)