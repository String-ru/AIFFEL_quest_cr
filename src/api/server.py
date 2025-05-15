from fastapi import FastAPI, WebSocket, Form, Query
from fastapi.responses import StreamingResponse, FileResponse
from fastapi.staticfiles import StaticFiles
import asyncio
from io import BytesIO
from src.models.tts_model import TTSModel
import os

app = FastAPI()

# 정적 파일 디렉토리가 없으면 생성
if not os.path.exists("static"):
    os.makedirs("static")

# 정적 파일 마운트
app.mount("/static", StaticFiles(directory="static"), name="static")

# TTS 모델 로드
def load_tts_model():
    print("TTS 모델 로드 중...")
    return TTSModel()

# 문장 분리 함수
def split_into_sentences(text):
    # 간단한 문장 분리 로직
    return text.split('. ')

tts_model = load_tts_model()

@app.get("/")
async def root():
    return {"message": "TTS API is running"}

@app.get("/test")
async def test_page():
    return FileResponse("test_client.html")

@app.post("/tts/stream")
async def stream_tts(
    text: str = Form(...), 
    speaker_id: int = Form(0),
    language: str = Form(None)
):
    async def generate():
        # 텍스트를 문장 단위로 분리
        sentences = split_into_sentences(text)
        
        for sentence in sentences:
            if sentence.strip():  # 빈 문장 건너뛰기
                # TTS 모델을 사용하여 음성 생성
                audio_data = tts_model.synthesize(sentence, speaker_id, language)
                
                yield audio_data
                
                # 자연스러운 흐름을 위한 짧은 대기
                await asyncio.sleep(0.1)
    
    return StreamingResponse(generate(), media_type="audio/wav")

@app.get("/tts")
async def tts_get(
    text: str = Query(...),
    speaker_id: int = Query(0),
    language: str = Query(None)
):
    # 단일 요청으로 전체 오디오 생성
    audio_data = tts_model.synthesize(text, speaker_id, language)
    return StreamingResponse(BytesIO(audio_data), media_type="audio/wav")

@app.websocket("/tts/ws")
async def websocket_tts(websocket: WebSocket):
    await websocket.accept()
    
    while True:
        try:
            data = await websocket.receive_json()
            text = data.get("text", "")
            speaker_id = data.get("speaker_id", 0)
            language = data.get("language")
            
            sentences = split_into_sentences(text)
            
            for sentence in sentences:
                if sentence.strip():  # 빈 문장 건너뛰기
                    # TTS 모델을 사용하여 음성 생성
                    audio_data = tts_model.synthesize(sentence, speaker_id, language)
                    
                    await websocket.send_bytes(audio_data)
        except Exception as e:
            print(f"Error: {e}")
            break
