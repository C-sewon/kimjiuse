import json
import os
import re
import requests

RAPIDAPI_KEY = "5249a753fcmsh35ff61363d70ce4p1b5dbajsnf1d3573495cc"

def extract_shortcode(url: str) -> str:
    try:
        url = url.split("?")[0].rstrip("/")
        if "/p/" in url:
            return url.split("/p/")[-1]
        elif "/reel/" in url:
            return url.split("/reel/")[-1]
        return None
    except:
        return None

def collect_post(url: str) -> dict:
    shortcode = extract_shortcode(url)
    if shortcode is None:
        return None

    try:
        api_url = "https://instagram-looter2.p.rapidapi.com/post"

        headers = {
            "x-rapidapi-key": RAPIDAPI_KEY,
            "x-rapidapi-host": "instagram-looter2.p.rapidapi.com"
        }

        params = {"link": url}

        response = requests.get(
            api_url,
            headers=headers,
            params=params)

        data = response.json()

        # 캡션 추출
        caption = ""
        try:
            edges = data.get(
                'edge_media_to_caption', {}).get(
                'edges', [])
            if edges:
                caption = edges[0]['node']['text']
        except:
            caption = ""

        # 해시태그 추출
        hashtags = re.findall(r'#\w+', caption)

        result = {
            "post_id": shortcode,
            "caption": caption,
            "hashtags": " ".join(hashtags),
            "image_url": response.json().get(
                'display_url', ''),
        }

        print(f"수집 완료: {shortcode}")
        print(f"캡션: {caption[:50] if caption else '없음'}")
        return result

    except Exception as e:
        print(f"수집 오류: {e}")
        return None
    
def save_to_json(data: dict,
                  filepath: str) -> bool:
    try:
        os.makedirs(
            os.path.dirname(filepath),
            exist_ok=True)

        existing = []
        if os.path.exists(filepath):
            with open(filepath, "r",
                      encoding="utf-8") as f:
                existing = json.load(f)

        existing.append(data)

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