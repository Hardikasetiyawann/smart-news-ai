from fastapi import APIRouter
from app.schemas.summary import SummaryRequest, SummaryResponse
from app.services.summarizer import summarize_text

router = APIRouter()

@router.post("/summarize", response_model=SummaryResponse)
def summarize(payload: SummaryRequest):
    summary = summarize_text(payload.text)
    return {
        "summary_text": summary,
        "model_name": "cahya/t5-base-indonesian-summarization-cased"
    }
