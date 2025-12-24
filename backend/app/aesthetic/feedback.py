import json
from openai import OpenAI

# OpenAI client (uses OPENAI_API_KEY from env)
client = OpenAI()

def generate_aesthetic_feedback_with_json(stats, score):
    prompt = f"""
You are an expert in computational aesthetics and photographic quality optimization.
Your goal is to suggest edits that will INCREASE a CLIP-based aesthetic score
(similar to the LAION aesthetic predictor used in this app).

A photo has the following analysis:
Current aesthetic score (0–10): {score}
Brightness: {stats['brightness']}
Contrast: {stats['contrast']}
Saturation: {stats['saturation']}
Sharpness: {stats['sharpness']}
Warmth: {stats['warmth']}

Guidelines:
- Always suggest at least subtle numeric adjustments for brightness, contrast, saturation, sharpness, and warmth.
- Avoid extreme or unnatural edits; small improvements are preferred.
- feedback_text must always contain 3–5 concise, actionable suggestions.
- Never respond with "No changes recommended" or leave values as default.

Return a single JSON object with these keys:
- brightness: multiplier (e.g., 1.1 means +10%)
- contrast: multiplier
- saturation: multiplier
- sharpness: multiplier
- warmth: integer (positive = warmer, negative = cooler)
- feedback_text: short human-readable guidance (3–5 concise, actionable suggestions)

Only return valid JSON. Do NOT include explanations or extra text.
"""


    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": prompt}],
        max_tokens=200,
        temperature=0.6,
    )
    content = response.choices[0].message.content.strip()
    try:
        data = json.loads(content)
    except json.JSONDecodeError:
        data = {
            "brightness": 1.0,
            "contrast": 1.0,
            "saturation": 1.0,
            "sharpness": 1.0,
            "warmth": 0,
            "feedback_text": "No changes recommended."
        }
    return data