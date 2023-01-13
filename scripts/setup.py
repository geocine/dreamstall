import os
import shutil
import requests
from shutil import unpack_archive

TEMP_DIR = os.environ.get("TEMP_DIR")
ROOT_DIR = os.environ.get("ROOT_DIR")
CONFIG_DIR = os.environ.get("CONFIG_DIR")
USER_PROFILE = os.environ.get("userprofile")

huggingface_dir = os.path.join(USER_PROFILE, ".huggingface")
if not os.path.exists(huggingface_dir):
    os.makedirs(huggingface_dir)

token_path = os.path.join(CONFIG_DIR, "token")
hugginface_token_path = os.path.join(huggingface_dir, "token")
if os.path.exists(token_path) and os.path.getsize(token_path) > 0:
    if not os.path.exists(hugginface_token_path) or os.path.getsize(hugginface_token_path) == 0:
        shutil.copy(token_path, os.path.join(huggingface_dir, "token"))
        print("Copied token to .huggingface")
    else:
        print("Token already exists in .huggingface")

files_to_download = [
    "https://github.com/geocine/dreamstall-binaries/raw/main/cextension.py",
    "https://github.com/geocine/dreamstall-binaries/raw/main/libbitsandbytes_cpu.dll",
    "https://github.com/geocine/dreamstall-binaries/raw/main/libbitsandbytes_cuda116.dll",
    "https://github.com/geocine/dreamstall-binaries/raw/main/main.py",
    "https://huggingface.co/datasets/geocine/dreamstall/resolve/bin/cudnn_windows.zip"
]

if not os.path.exists(TEMP_DIR):
    os.makedirs(TEMP_DIR)

for file_url in files_to_download:
    file_name = file_url.split("/")[-1]
    if not os.path.exists(os.path.join(TEMP_DIR, file_name)):
        print(f"Downloading {file_name}...")
        r = requests.get(file_url)
        open(os.path.join(TEMP_DIR, file_name), 'wb').write(r.content)
        print(f"  Downloaded {file_name}")
    else:
        print(f"{file_name} already exists")

dll_files = [
    "libbitsandbytes_cpu.dll",
    "libbitsandbytes_cuda116.dll"
]

for file_name in dll_files:
    print(f"Copying {file_name} to bitsandbytes")
    shutil.copy(os.path.join(TEMP_DIR, file_name), os.path.join(ROOT_DIR, "envs\\diffusers\\Lib\\site-packages\\bitsandbytes", file_name))
    print(f"  Copied {file_name} to bitsandbytes")

print("Copying cextension.py to bitsandbytes")
shutil.copy(os.path.join(TEMP_DIR, "cextension.py"), os.path.join(ROOT_DIR, "envs\\diffusers\\Lib\\site-packages\\bitsandbytes\\cextension.py"))
print("  Copied cextension.py to bitsandbytes")
print("Copying main.py to bitsandbytes\\cuda_setup")
shutil.copy(os.path.join(TEMP_DIR, "main.py"), os.path.join(ROOT_DIR, "envs\\diffusers\\Lib\\site-packages\\bitsandbytes\\cuda_setup\\main.py"))
print("  Copied main.py to bitsandbytes\\cuda_setup")

cudnn_zip = os.path.join(TEMP_DIR, "cudnn_windows.zip")
if os.path.exists(cudnn_zip):
    unpack_archive(cudnn_zip, os.path.join(TEMP_DIR, "cudnn_windows"))
    cudnn_path = os.path.join(TEMP_DIR, "cudnn_windows")
    for file_name in os.listdir(cudnn_path):
        print(f"Copying {file_name} to torch\\lib")
        shutil.copy(os.path.join(cudnn_path, file_name), os.path.join(ROOT_DIR, "envs\\diffusers\\Lib\\site-packages\\torch\\lib", file_name))
        print(f"  Copied {file_name} to torch\\lib")