# import os
# from os.path import expanduser
# from urllib.request import urlretrieve
# from io import BytesIO
# import base64
# import json

# import torch
# import torch.nn as nn
# import numpy as np
# from PIL import Image, ImageStat, ImageEnhance
# from transformers import CLIPProcessor, CLIPModel
# from fastapi import FastAPI, File, UploadFile
# import uvicorn
# from openai import OpenAI

# # -----------------------------
# # OPENAI CLIENT
# # -----------------------------
# client = OpenAI()  # Make sure OPENAI_API_KEY is set

# # -----------------------------
# # LOAD AESTHETIC MODEL
# # -----------------------------
# def get_aesthetic_model(clip_model="vit_l_14"):
#     home = expanduser("~")
#     cache_folder = os.path.join(home, ".cache", "emb_reader")
#     os.makedirs(cache_folder, exist_ok=True)

#     fname = f"sa_0_4_{clip_model}_linear.pth"
#     path_to_model = os.path.join(cache_folder, fname)

#     if not os.path.exists(path_to_model):
#         url_model = f"https://github.com/LAION-AI/aesthetic-predictor/blob/main/{fname}?raw=true"
#         print("Downloading aesthetic model weights to:", path_to_model)
#         urlretrieve(url_model, path_to_model)

#     m = nn.Linear(768, 1)
#     state = torch.load(path_to_model, map_location="cpu")
#     m.load_state_dict(state)
#     m.eval()
#     return m

# # -----------------------------
# # IMAGE ENHANCEMENT FUNCTION
# # -----------------------------
# def apply_changes(image: Image.Image, changes: dict):
#     img = image.copy()

#     img = ImageEnhance.Brightness(img).enhance(changes["brightness"])
#     img = ImageEnhance.Contrast(img).enhance(changes["contrast"])
#     img = ImageEnhance.Color(img).enhance(changes["saturation"])
#     img = ImageEnhance.Sharpness(img).enhance(changes["sharpness"])

#     if changes["warmth"] != 0:
#         r, g, b = img.split()
#         r = r.point(lambda i: min(255, max(0, i + changes["warmth"])))
#         b = b.point(lambda i: min(255, max(0, i - changes["warmth"])))
#         img = Image.merge("RGB", (r, g, b))

#     return img

# # -----------------------------
# # IMAGE STATS FUNCTION
# # -----------------------------
# def generate_image_stats(image: Image.Image):
#     grayscale = image.convert("L")
#     gray_stats = ImageStat.Stat(grayscale)

#     brightness = gray_stats.mean[0]
#     contrast = gray_stats.stddev[0]

#     hsv = image.convert("HSV")
#     saturation = ImageStat.Stat(hsv.split()[1]).mean[0]

#     gray_np = np.array(grayscale)
#     sharpness = np.var(gray_np)

#     r, g, b = image.split()
#     warmth = ImageStat.Stat(r).mean[0] - ImageStat.Stat(b).mean[0]

#     return {
#         "brightness": round(brightness, 2),
#         "contrast": round(contrast, 2),
#         "saturation": round(saturation, 2),
#         "sharpness": round(sharpness, 2),
#         "warmth": round(warmth, 2),
#     }

# # -----------------------------
# # OPENAI FEEDBACK FUNCTION
# # -----------------------------
# def generate_aesthetic_feedback_with_json(stats, score):
#     prompt = f"""
# You are an expert in computational aesthetics and photographic quality optimization.
# Your goal is to suggest edits that will INCREASE a CLIP-based aesthetic score
# (similar to the LAION aesthetic predictor used in this app).

# A photo has the following analysis:
# Current aesthetic score (0–10): {score}
# Brightness: {stats['brightness']}
# Contrast: {stats['contrast']}
# Saturation: {stats['saturation']}
# Sharpness: {stats['sharpness']}
# Warmth: {stats['warmth']}

# Guidelines:
# - Always suggest at least subtle numeric adjustments for brightness, contrast, saturation, sharpness, and warmth.
# - Avoid extreme or unnatural edits; small improvements are preferred.
# - feedback_text must always contain 3–5 concise, actionable suggestions.
# - Never respond with "No changes recommended" or leave values as default.

# Return a single JSON object with these keys:
# - brightness: multiplier (e.g., 1.1 means +10%)
# - contrast: multiplier
# - saturation: multiplier
# - sharpness: multiplier
# - warmth: integer (positive = warmer, negative = cooler)
# - feedback_text: short human-readable guidance (3–5 concise, actionable suggestions)

# Only return valid JSON. Do NOT include explanations or extra text.
# """


#     response = client.chat.completions.create(
#         model="gpt-4o-mini",
#         messages=[{"role": "user", "content": prompt}],
#         max_tokens=200,
#         temperature=0.6,
#     )
#     content = response.choices[0].message.content.strip()
#     try:
#         data = json.loads(content)
#     except json.JSONDecodeError:
#         data = {
#             "brightness": 1.0,
#             "contrast": 1.0,
#             "saturation": 1.0,
#             "sharpness": 1.0,
#             "warmth": 0,
#             "feedback_text": "No changes recommended."
#         }
#     return data

# # -----------------------------
# # INIT MODELS
# # -----------------------------
# aesthetic_model = get_aesthetic_model("vit_l_14")
# clip_model_name = "openai/clip-vit-large-patch14"
# clip_model = CLIPModel.from_pretrained(clip_model_name)
# processor = CLIPProcessor.from_pretrained(clip_model_name)

# # -----------------------------
# # FASTAPI APP
# # -----------------------------
# app = FastAPI()

# @app.post("/upload")
# async def upload(file: UploadFile = File(...)):
#     img_bytes = await file.read()
#     image = Image.open(BytesIO(img_bytes)).convert("RGB")

#     # --- CLIP AESTHETIC SCORE ---
#     inputs = processor(images=image, return_tensors="pt")
#     with torch.no_grad():
#         img_embeds = clip_model.get_image_features(**inputs)
#         img_embeds = img_embeds / img_embeds.norm(p=2, dim=-1, keepdim=True)
#         score = aesthetic_model(img_embeds).item()
#     final_score = round(score, 2)

#     # --- IMAGE STATS ---
#     stats = generate_image_stats(image)

#     # --- OPENAI FEEDBACK ---
#     result = generate_aesthetic_feedback_with_json(stats, final_score)
#     changes = {k: result[k] for k in ["brightness", "contrast", "saturation", "sharpness", "warmth"]}
#     feedback_text = result["feedback_text"]

#     # --- APPLY CHANGES AND ENCODE ---
#     edited_image = apply_changes(image, changes)
#     buffered = BytesIO()
#     edited_image.save(buffered, format="JPEG")
#     img_str = base64.b64encode(buffered.getvalue()).decode()

#     return {
#         "score": final_score,
#         "feedback": feedback_text,
#         "stats": stats,
#         "edited_image_base64": img_str
#     }

# # -----------------------------
# # RUN SERVER
# # -----------------------------
# if __name__ == "__main__":
#     uvicorn.run(app, host="0.0.0.0", port=8000)

from fastapi import FastAPI
from app.server import router

app = FastAPI(title="Aesthetic Scoring API")

app.include_router(router)

@app.get("/")
def health():
    return {"status": "running"}
