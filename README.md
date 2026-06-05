# 📌 인스타그램 북마크 자동분류 AI

인스타그램 게시물 URL을 입력하면
AI가 자동으로 카테고리를 분류해서
저장해주는 앱입니다.

---

## 🛠️ 기술 스택

| 분류 | 기술 |
|------|------|
| 분류 엔진 | C++17 |
| DB | SQLite3 |
| 앱 UI | Flutter (Windows) |
| 데이터 수집 | Python + RapidAPI |
| API 서버 | FastAPI |
| 빌드 | CMake + MinGW |
| 협업 | Git / GitHub |
| 로깅 | 자체 구현 Logger |

---

## 👥 팀원 역할

| 역할 | 이름 | 담당 |
|------|------|------|
| 팀장 | 최세원 | 전체 통합, SQLite DB, Flutter FFI, CMake, Git 관리 |
| 팀원 | 황지유 | 데이터 수집, RapidAPI 연동, FastAPI 서버 |
| 팀원 | 김민진 | 텍스트 분류 엔진, 피드백 시스템, Logger |
| 팀원 | 홍유진 | 이미지 분석, Flutter UI, 카테고리 화면 |

---

## 🚀 실행 방법

### 사전 준비
Python 3.11 이상
Flutter SDK
MinGW (C++ 컴파일러)
CMake

### 1. 패키지 설치
```bash
cd collector
python -m pip install fastapi uvicorn requests python-dotenv
```

### 2. '발표'폴더로 이동
server.exe 파일과 flutter.exe 파일 순서대로 실행
---

## 📁 프로젝트 구조