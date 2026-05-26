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

class UrlRequest(BaseModel):
    url: str

class CollectResponse(BaseModel):
    success: bool
    post_id: str = ""
    caption: str = ""
    hashtags: str = ""
    message: str = ""

@app.get("/")
def root():
    return {"message": "북마크 분류기 서버 동작 중"}

@app.post("/collect", response_model=CollectResponse)
def collect(request: UrlRequest):
    """
    인스타그램 URL에서 게시물 데이터 수집
    """
    print(f"수집 요청: {request.url}")

    # 데이터 수집
    data = collect_post(request.url)

    if data is None:
        return CollectResponse(
            success=False,
            message="수집 실패: URL을 확인해주세요"
        )

    # JSON 저장
    save_to_json(data, "data/bookmarks.json")

    return CollectResponse(
        success=True,
        post_id=data["post_id"],
        caption=data["caption"],
        hashtags=data["hashtags"],
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