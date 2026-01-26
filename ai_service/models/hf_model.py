from transformers import pipeline

MODEL_NAME = "cahya/t5-base-indonesian-summarization-cased"

summarizer_pipeline = pipeline(
    "summarization",
    model=MODEL_NAME,
    tokenizer=MODEL_NAME,
    use_fast=False
)
