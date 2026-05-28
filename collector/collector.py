import time
import json
import os
import re
import requests
from bs4 import BeautifulSoup

INSTAGRAM_ID = "horse.40159501"
INSTAGRAM_PW = "cbnuossbasic2025"

# 세션 생성
session = requests.Session()
session.headers.update({
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Language': 'ko-KR,ko;q=0.9,en;q=0.8',
    'Accept-Encoding': 'gzip, deflate, br',
    'Connection': 'keep-alive',
})

def login():
    try:
        # 먼저 메인 페이지 접속
        session.get('https://www.instagram.com/')
        
        # csrf 토큰 가져오기
        r = session.get(
            'https://www.instagram.com/accounts/login/')
        
        csrf_token = session.cookies.get('csrftoken', '')
        
        session.headers.update({
            'X-CSRFToken': csrf_token,
            'X-Instagram-AJAX': '1',
            'X-Requested-With': 'XMLHttpRequest',
            'Referer': 'https://www.instagram.com/accounts/login/',
            'Origin': 'https://www.instagram.com',
        })

        time.sleep(2)

        payload = {
            'username': INSTAGRAM_ID,
            'enc_password': f'#PWD_INSTAGRAM_BROWSER:0:0:{INSTAGRAM_PW}',
            'queryParams': '{}',
            'optIntoOneTap': 'false',
            'trustedDeviceRecords': '{}',
        }

        response = session.post(
            'https://www.instagram.com/accounts/login/ajax/',
            data=payload)

        data = response.json()

        if data.get('authenticated'):
            print("✅ 로그인 성공")
            return True
        else:
            print(f"❌ 로그인 실패: {data}")
            return False

    except Exception as e:
        print(f"로그인 오류: {e}")
        return False

# 시작시 로그인
login()

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
        clean_url = f"https://www.instagram.com/p/{shortcode}/"
        response = session.get(clean_url)

        caption = ""
        hashtags = []

        # 방법 1: og:description에서 추출
        soup = BeautifulSoup(response.text, 'html.parser')
        meta_desc = soup.find(
            'meta', {'property': 'og:description'})
        if meta_desc:
            content = meta_desc.get('content', '')
            # "123 Likes, 4 Comments - 아이디 on Instagram: "캡션""
            if '": "' in content:
                caption = content.split('": "')[-1].rstrip('"')
            elif ': ' in content:
                caption = content.split(': ', 1)[-1]
            else:
                caption = content

        # 방법 2: JSON 데이터에서 추출
        if not caption:
            json_match = re.search(
                r'"edge_media_to_caption".*?"text":"(.*?)"',
                response.text)
            if json_match:
                caption = json_match.group(1)

        # 방법 3: script 태그에서 추출
        if not caption:
            scripts = soup.find_all('script')
            for script in scripts:
                if script.string and 'caption' in str(script.string):
                    cap_match = re.search(
                        r'"caption":"(.*?)"',
                        str(script.string))
                    if cap_match:
                        caption = cap_match.group(1)
                        break

        # 해시태그 추출
        hashtags = re.findall(r'#\w+', caption)

        data = {
            "post_id": shortcode,
            "caption": caption,
            "hashtags": " ".join(hashtags),
            "image_url": clean_url,
        }

        print(f"수집 완료: {shortcode}")
        print(f"캡션: {caption[:50] if caption else '없음'}")
        return data

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