import re
from models.hf_model import summarizer_pipeline



def clean_news_text(text: str) -> str:

    text = re.sub(r'^[A-Z\s,.-]+-\s*', '', text)
    text = re.sub(r'\(.*?\)', '', text)
    text = re.sub(r'\s+', ' ', text)
    return text.strip()


def split_sentences(text: str):

    return [
        s.strip()
        for s in text.split('. ')
        if len(s.strip()) > 20
    ]


def chunk_text(sentences, max_sentences=5):
    """
    Membagi kalimat menjadi chunk kecil
    """
    for i in range(0, len(sentences), max_sentences):
        yield '. '.join(sentences[i:i + max_sentences])



def summarize_chunk(text: str) -> str:
    """
    Ringkasan per bagian (abstractive)
    """
    result = summarizer_pipeline(
        text,
        max_new_tokens=80,
        min_new_tokens=40,
        do_sample=True,
        top_p=0.9,
        temperature=0.8,
        num_beams=3,
        truncation=True
    )
    return result[0]["summary_text"].strip()


def summarize_text(text: str) -> str:


    if not text or len(text.split()) < 50:
        return text

    # Bersihkan teks
    text = clean_news_text(text)

    # Pecah jadi kalimat
    sentences = split_sentences(text)

    # Jika sedikit kalimat, langsung ringkas
    if len(sentences) <= 5:
        return summarize_chunk(text)

    # Anchor (lead berita)
    anchor = '. '.join(sentences[:2])

    # Body
    body_sentences = sentences[2:]
    summaries = []

    for chunk in chunk_text(body_sentences):
        summaries.append(summarize_chunk(chunk))

    body_summary = ' '.join(summaries)

    # Gabungkan anchor + body summary
    final_text = f"{anchor}. {body_summary}"

    # Final summarization (deterministic)
    final_result = summarizer_pipeline(
        final_text,
        max_new_tokens=120,
        min_new_tokens=60,
        do_sample=False,
        num_beams=4,
        truncation=True
    )

    return final_result[0]["summary_text"].strip()
