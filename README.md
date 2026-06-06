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

### 2. exe 파일 실행
collector/windows/dist 안에 있는 server.exe 파일과
flutter_app/build/windows/x64/runner/Release 안에 있는 flutter.exe 파일을 순서대로 실행

---

## 🔄 시스템 흐름
1. URL 입력 (Flutter UI)
↓
2. Python FastAPI 서버
→ RapidAPI로 Instagram 데이터 수집
→ 캡션 / 해시태그 / 이미지 추출
↓
3. C++ 분류 엔진 (FFI)
→ 텍스트 키워드 분석
→ 카테고리 자동 분류
→ 신뢰도 점수 계산
↓
4. SQLite DB 저장
→ 분류 결과 영구 저장
↓
5. Flutter UI 표시
→ 카테고리별 게시물 목록
→ 실제 인스타그램 이미지 표시
→ 홈화면 카운팅 업데이트

---

## 📂 카테고리 분류
🍔 맛집      🏃 운동      👗 패션
💻 개발      💄 뷰티      🐶 반려동물
✈️  여행      🏠 인테리어   📚 독서
📌 기타

---

## 🔧 개발 환경
OS: Windows 10/11
IDE: VSCode
C++ 표준: C++17
Flutter: 3.x
Python: 3.11+
DB: SQLite3 (vcpkg)

---

## 📋 Git 브랜치 전략
main     ← 최종 완성본
develop  ← 통합 테스트
feature/ ← 각 팀원 작업 브랜치
├── feature/main-db : 팀장 최세원
├── feature/data-pipeline  : 팀원 황지유
├── feature/text-classifier  : 팀원 김민진
└── feature/image-analyzer  : 팀원 홍유진
