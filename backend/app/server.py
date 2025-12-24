from fastapi import APIRouter, UploadFile, File
from io import BytesIO
import base64
from PIL import Image

import torch

from app.aesthetic.model import (
    clip_model,
    processor,
    aesthetic_model,
    compute_aesthetic_score,
)
from app.aesthetic.utils import (
    generate_image_stats,
    apply_changes,
)
from app.aesthetic.feedback import generate_aesthetic_feedback_with_json

router = APIRouter()

@router.post("/upload")
async def upload(file: UploadFile = File(...)):
    img_bytes = await file.read()
    image = Image.open(BytesIO(img_bytes)).convert("RGB")

    # --- AESTHETIC SCORE ---
    final_score = compute_aesthetic_score(image)

    # --- IMAGE STATS ---
    stats = generate_image_stats(image)

    # --- OPENAI FEEDBACK ---
    result = generate_aesthetic_feedback_with_json(stats, final_score)

    changes = {k: result[k] for k in [
        "brightness", "contrast", "saturation", "sharpness", "warmth"
    ]}
    feedback_text = result["feedback_text"]

    # --- APPLY CHANGES ---
    edited_image = apply_changes(image, changes)
    buffered = BytesIO()
    edited_image.save(buffered, format="JPEG")
    img_str = base64.b64encode(buffered.getvalue()).decode()

    return {
        "score": final_score,
        "feedback": feedback_text,
        "stats": stats,
        "edited_image_base64": img_str
    }
