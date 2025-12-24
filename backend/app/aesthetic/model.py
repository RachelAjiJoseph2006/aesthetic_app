import os
from os.path import expanduser
from urllib.request import urlretrieve

import torch
import torch.nn as nn
from PIL import Image
from transformers import CLIPModel, CLIPProcessor

# -----------------------------
# LOAD AESTHETIC LINEAR MODEL
# -----------------------------
def get_aesthetic_model(clip_model: str = "vit_l_14"):
    home = expanduser("~")
    cache_folder = os.path.join(home, ".cache", "emb_reader")
    os.makedirs(cache_folder, exist_ok=True)

    fname = f"sa_0_4_{clip_model}_linear.pth"
    path_to_model = os.path.join(cache_folder, fname)

    if not os.path.exists(path_to_model):
        url_model = (
            f"https://github.com/LAION-AI/aesthetic-predictor/"
            f"blob/main/{fname}?raw=true"
        )
        print("Downloading aesthetic model:", path_to_model)
        urlretrieve(url_model, path_to_model)

    model = nn.Linear(768, 1)
    state = torch.load(path_to_model, map_location="cpu")
    model.load_state_dict(state)
    model.eval()

    return model


# -----------------------------
# INIT MODELS (RUN ONCE)
# -----------------------------
clip_model_name = "openai/clip-vit-large-patch14"

clip_model = CLIPModel.from_pretrained(clip_model_name)
processor = CLIPProcessor.from_pretrained(clip_model_name)
aesthetic_model = get_aesthetic_model("vit_l_14")


# -----------------------------
# AESTHETIC SCORE FUNCTION
# -----------------------------
def compute_aesthetic_score(image: Image.Image) -> float:
    """
    Takes a PIL image and returns a CLIP-based aesthetic score.
    """
    inputs = processor(images=image, return_tensors="pt")

    with torch.no_grad():
        img_embeds = clip_model.get_image_features(**inputs)
        img_embeds = img_embeds / img_embeds.norm(p=2, dim=-1, keepdim=True)
        score = aesthetic_model(img_embeds).item()

    return round(score, 2)
