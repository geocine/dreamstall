import os
import torch
from torch import autocast
from diffusers import StableDiffusionPipeline, DDIMScheduler, EulerAncestralDiscreteScheduler
# from IPython.display import display

model_path = "./train/dog/output/800"             # If you want to use previously trained model saved in gdrive, replace this with the full path of model in gdrive

# scheduler = DDIMScheduler(beta_start=0.00085, beta_end=0.012, beta_schedule="scaled_linear", clip_sample=False, set_alpha_to_one=False)
# https://github.com/huggingface/diffusers/pull/1019#issuecomment-1302243448
scheduler = EulerAncestralDiscreteScheduler(beta_start=0.00085, beta_end=0.012, beta_schedule="scaled_linear", num_train_timesteps=1000)
pipe = StableDiffusionPipeline.from_pretrained(model_path, scheduler=scheduler, safety_checker=None, torch_dtype=torch.float16).to("cuda")

g_cuda = None

#@markdown Can set random seed here for reproducibility.
g_cuda = torch.Generator(device='cuda')
seed = g_cuda.seed()
# seed = 6771873678177593 #@param {type:"number"}
g_cuda.manual_seed(seed)

#@title Run for generating images.

prompt = "photo of zwx dog" #@param {type:"string"}
negative_prompt = "" #@param {type:"string"}
num_samples = 5 #@param {type:"number"}
guidance_scale = 9 #@param {type:"number"}
num_inference_steps = 160 #@param {type:"number"}
height = 512 #@param {type:"number"}
width = 512 #@param {type:"number"}

with autocast("cuda"), torch.inference_mode():
    images = pipe(
        prompt,
        height=height,
        width=width,
        negative_prompt=negative_prompt,
        num_images_per_prompt=num_samples,
        num_inference_steps=num_inference_steps,
        guidance_scale=guidance_scale,
        generator=g_cuda
    ).images

IMAGES_OUTPUT_DIR = "./images_output"
if not os.path.exists(IMAGES_OUTPUT_DIR):
    os.makedirs(IMAGES_OUTPUT_DIR)

# save image based on index
for i, img in enumerate(images):
    img.save(f"images_output/sample_{seed}_{i}.png")