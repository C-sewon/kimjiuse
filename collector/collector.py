# collector/collector.py
import instaloader
import json
import os

# Instaloader 객체 생성
L = instaloader.Instaloader()

def extract_shortcode(url: str) -> str:
    """
    인스타그램 URL에서 shortcode 추출
    """
    try:
        # ?utm_source 같은 파라미터 제거
        url = url.split("?")[0]
        url = url.rstrip("/")

        if "/p/" in url:
            shortcode = url.split("/p/")[-1]
            return shortcode
        elif "/reel/" in url:
            shortcode = url.split("/reel/")[-1]
            return shortcode
        return None
    except Exception as e:
        print(f"URL 파싱 오류: {e}")
        return None
    
def collect_post(url: str) -> dict:
    """
    인스타그램 URL에서 게시물 데이터 수집
    """
    shortcode = extract_shortcode(url)
    if shortcode is None:
        return None

    try:
        # 게시물 데이터 수집
        post = instaloader.Post.from_shortcode(
            L.context, shortcode)

        # 해시태그 추출
        hashtags = " ".join(
            ["#" + h for h in post.hashtags])

        # 캡션 추출
        caption = post.caption or ""

        # 해시태그 제거한 순수 캡션
        pure_caption = caption
        for tag in post.hashtags:
            pure_caption = pure_caption.replace(
                "#" + tag, "").strip()

        data = {
            "post_id": shortcode,
            "caption": pure_caption,
            "hashtags": hashtags,
            "image_url": post.url,
            "likes": post.likes,
            "date": str(post.date)
        }

        print(f"수집 완료: {shortcode}")
        return data

    except Exception as e:
        print(f"수집 오류: {e}")
        return None

def save_to_json(data: dict,
                  filepath: str) -> bool:
    """
    수집한 데이터를 JSON 파일로 저장
    """
    try:
        os.makedirs(
            os.path.dirname(filepath),
            exist_ok=True)

        # 기존 파일 있으면 불러오기
        existing = []
        if os.path.exists(filepath):
            with open(filepath, "r",
                      encoding="utf-8") as f:
                existing = json.load(f)

        # 새 데이터 추가
        existing.append(data)

        # 저장
        with open(filepath, "w",
                  encoding="utf-8") as f:
            json.dump(existing, f,
                      ensure_ascii=False,
                      indent=2)

        print(f"저장 완료: {filepath}")
        return True

    except Exception as e:
        print(f"저장 오류: {e}")
        return False