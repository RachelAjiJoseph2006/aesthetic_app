import numpy as np
from PIL import Image, ImageStat, ImageEnhance


# -----------------------------
# IMAGE STATS
# -----------------------------
def generate_image_stats(image: Image.Image) -> dict:
    grayscale = image.convert("L")
    gray_stats = ImageStat.Stat(grayscale)

    brightness = gray_stats.mean[0]
    contrast = gray_stats.stddev[0]

    hsv = image.convert("HSV")
    saturation = ImageStat.Stat(hsv.split()[1]).mean[0]

    gray_np = np.array(grayscale)
    sharpness = np.var(gray_np)

    r, g, b = image.split()
    warmth = ImageStat.Stat(r).mean[0] - ImageStat.Stat(b).mean[0]

    return {
        "brightness": round(brightness, 2),
        "contrast": round(contrast, 2),
        "saturation": round(saturation, 2),
        "sharpness": round(sharpness, 2),
        "warmth": round(warmth, 2),
    }


# -----------------------------
# IMAGE EDITING
# -----------------------------
def apply_changes(image: Image.Image, changes: dict) -> Image.Image:
    img = image.copy()

    img = ImageEnhance.Brightness(img).enhance(changes["brightness"])
    img = ImageEnhance.Contrast(img).enhance(changes["contrast"])
    img = ImageEnhance.Color(img).enhance(changes["saturation"])
    img = ImageEnhance.Sharpness(img).enhance(changes["sharpness"])

    warmth = changes.get("warmth", 0)
    if warmth != 0:
        r, g, b = img.split()
        r = r.point(lambda i: min(255, max(0, i + warmth)))
        b = b.point(lambda i: min(255, max(0, i - warmth)))
        img = Image.merge("RGB", (r, g, b))

    return img
