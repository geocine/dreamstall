$Env:BIN_DIR = "$PSScriptRoot\..\bin"
$Env:CONFIG_DIR = "$PSScriptRoot\..\configs"
$Env:BASE_DIR = "$PSScriptRoot\.."
$Env:TEMP_DIR = "$PSScriptRoot\..\temp"
$Env:ROOT_DIR = "$PSScriptRoot\..\root"
$Env:MAMBA_ROOT_PREFIX = "$PSScriptRoot\..\root"
$Env:MAMBA_EXE = "$PSScriptRoot\..\bin\micromamba.exe"
$Env:DIFFUSERS_URL = "git+https://github.com/huggingface/diffusers.git@244e16a7abfabce9e606b950af349062df40e437"
$Env:XFORMERS_URL = "diffusers"

& "$Env:BIN_DIR\micromamba.exe" create -n diffusers python=3.10 -c conda-forge -r "$Env:ROOT_DIR" -y
# Check if the environment is already active
if ($env:CONDA_DEFAULT_ENV -eq "diffusers") {
    Write-Host "diffusers environment already active"
} else {
    (& "$Env:BIN_DIR\micromamba.exe" 'shell' 'hook' -s 'powershell' -p "$Env:ROOT_DIR") | Out-String | Invoke-Expression
    micromamba activate diffusers
}
pip install torch==1.12.1+cu116 torchvision==0.13.1+cu116 --extra-index-url https://download.pytorch.org/whl/cu116
pip install pytorch_lightning
pip install -U $Env:DIFFUSERS_URL
pip install -U -r "$Env:BASE_DIR\requirements.txt"
pip install -U -I --no-deps $Env:XFORMERS_URL
python "$PSScriptRoot\setup.py"