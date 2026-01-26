from pydantic import BaseModel

class SummaryRequest(BaseModel):
    text: str

class SummaryResponse(BaseModel):
    summary_text: str
    model_name: str
