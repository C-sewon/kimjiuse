# collector/server.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import json
import os
import sys

# collector.py 임포트
sys.path.append(os.path.dirname(__file__))
from collector import collect_post, save_to_json

app = FastAPI()

# Flutter에서 접근 허용
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

def classify_text(caption: str,
                  hashtags: str) -> str:
    text = caption + " " + hashtags

    if any(k in text for k in
           ["맛집", "점심", "카페", "커피",
            "food", "먹스타그램"]):
        return "맛집"
    elif any(k in text for k in
             ["개발", "코딩", "coding",
              "github", "프로그래밍"]):
        return "개발"
    elif any(k in text for k in
             ["여행", "제주도", "바다",
              "travel", "vacation"]):
        return "여행"
    elif any(k in text for k in
             ["운동", "헬스", "fitness",
              "workout", "gym"]):
        return "운동"
    elif any(k in text for k in
             ["패션", "ootd", "코디", "옷"]):
        return "패션"
    elif any(k in text for k in
             ["뷰티", "메이크업", "화장",
              "makeup"]):
        return "뷰티"
    elif any(k in text for k in
             ["강아지", "고양이", "반려동물",
              "펫", "pet"]):
        return "반려동물"
    elif any(k in text for k in
             ["인테리어", "홈데코", "집꾸미기"]):
        return "인테리어"
    elif any(k in text for k in
             ["독서", "책", "북스타그램"]):
        return "독서"
    else:
        return "기타"

class UrlRequest(BaseModel):
    url: str

class CollectResponse(BaseModel):
    success: bool
    post_id: str = ""
    caption: str = ""
    hashtags: str = ""
    catagory: str = ""
    message: str = ""

class SaveRequest(BaseModel):
    post_id: str
    caption: str
    hashtags: str
    category: str
    confidence: float

@app.post("/save")
def save(request: SaveRequest):
    data = {
        "post_id": request.post_id,
        "caption": request.caption,
        "hashtags": request.hashtags,
        "category": request.category,
        "confidence": request.confidence,
    }
    save_to_json(data, "data/bookmarks.json")
    return {"success": True}

@app.get("/")
def root():
    return {"message": "북마크 분류기 서버 동작 중"}

@app.post("/collect", response_model=CollectResponse)
def collect(request: UrlRequest):
    print(f"수집 요청: {request.url}")

    # 데이터 수집
    data = collect_post(request.url)

    if data is None:
        return CollectResponse(
            success=False,
            message="수집 실패: URL을 확인해주세요"
        )

    # C++ 엔진으로 분류
    category = classify_text(
        data["caption"], data["hashtags"])

    # category 추가해서 저장
    data["category"] = category

    # JSON 저장
    save_to_json(data, "data/bookmarks.json")

    return CollectResponse(
        success=True,
        post_id=data["post_id"],
        caption=data["caption"],
        hashtags=data["hashtags"],
        category=category,
        message="수집 성공"
    )

@app.get("/bookmarks")
def get_bookmarks():
    """
    저장된 북마크 목록 반환
    """
    try:
        with open("data/bookmarks.json", "r",
                  encoding="utf-8") as f:
            bookmarks = json.load(f)
        return {"bookmarks": bookmarks}
    except:
        return {"bookmarks": []}

@app.delete("/bookmarks/{post_id}")
def delete_bookmark(post_id: str):
    """
    북마크 삭제
    """
    try:
        with open("data/bookmarks.json", "r",
                  encoding="utf-8") as f:
            bookmarks = json.load(f)

        bookmarks = [b for b in bookmarks
                     if b["post_id"] != post_id]

        with open("data/bookmarks.json", "w",
                  encoding="utf-8") as f:
            json.dump(bookmarks, f,
                      ensure_ascii=False,
                      indent=2)

        return {"success": True}
    except:
        return {"success": False}