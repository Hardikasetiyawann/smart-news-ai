const AI_SERVICE_URL = "http://127.0.0.1:8001/api/summarize";

async function requestAISummary(text) {
  const response = await fetch(AI_SERVICE_URL, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ text }),
  });

  if (!response.ok) {
    const errText = await response.text();
    throw new Error(`AI service error: ${errText}`);
  }

  const data = await response.json();

  return {
    summary_text: data.summary_text,
    model_name: data.model_name,
  };
}

module.exports = {
  requestAISummary,
};
