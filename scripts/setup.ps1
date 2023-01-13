$Env:BIN_DIR = "$PSScriptRoot\..\bin"
$Env:CONFIG_DIR = "$PSScriptRoot\..\configs"
$Env:BASE_DIR = "$PSScriptRoot\.."
$Env:TEMP_DIR = "$PSScriptRoot\..\temp"
$Env:ROOT_DIR = "$PSScriptRoot\..\root"
$Env:MAMBA_ROOT_PREFIX = "$PSScriptRoot\..\root"
$Env:MAMBA_EXE = "$PSScriptRoot\..\bin\micromamba.exe"

& "$Env:BIN_DIR\micromamba.exe" create -n diffusers python=3.10 -c conda-forge -r "$Env:ROOT_DIR" -y
(& "$Env:BIN_DIR\micromamba.exe" 'shell' 'hook' -s 'powershell' -p "$Env:ROOT_DIR") | Out-String | Invoke-Expression
micromamba activate diffusers
pip install torch==1.12.1+cu116 torchvision==0.13.1+cu116 --extra-index-url https://download.pytorch.org/whl/cu116
pip install pytorch_lightning
pip install -U diffusers
pip install -U -r "$Env:BASE_DIR\requirements.txt"
pip install -U -I --no-deps https://github.com/geocine/dreamstall-binaries/releases/download/c116-p310-t112/xformers-0.0.14.dev0-cp310-cp310-win_amd64.whl
python "$PSScriptRoot\setup.py"