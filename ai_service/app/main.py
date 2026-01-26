from fastapi import FastAPI
from app.api.summarize import router as summarize_router

app = FastAPI(title="AI Summary Service")

app.include_router(summarize_router, prefix="/api")

@app.get("/")
def health_check():
    return {"status": "ok"}

