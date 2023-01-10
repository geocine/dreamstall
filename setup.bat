@CALL mkdir root
@IF NOT EXIST %userprofile%\.huggingface (
    @CALL mkdir %userprofile%\.huggingface
)
@COPY %~dp0token %userprofile%\.huggingface\token
@CALL "%~dp0micromamba.exe" create -n diffusers python=3.10 -c conda-forge -r "%~dp0root" -y
@CALL "%~dp0micromamba.exe" shell init --shell=cmd.exe --prefix="%~dp0root"
@CALL "%~dp0root\condabin\micromamba.bat" activate diffusers
@CALL pip install torch==1.12.1+cu116 torchvision==0.13.1+cu116 --extra-index-url https://download.pytorch.org/whl/cu116
@CALL pip install pytorch_lightning
@CALL pip install -U diffusers
@CALL pip install -U -r %~dp0requirements.txt
@CALL pip install -U -I --no-deps https://github.com/geocine/dreamstall-binaries/releases/download/c116-p310-t112/xformers-0.0.14.dev0-cp310-cp310-win_amd64.whl
@IF NOT EXIST %~dp0temp\cextension.py (
    @CALL %~dp0got --dir %~dp0temp https://github.com/geocine/dreamstall-binaries/raw/main/cextension.py
)
@IF NOT EXIST %~dp0temp\libbitsandbytes_cpu.dll (
    @CALL %~dp0got --dir %~dp0temp https://github.com/geocine/dreamstall-binaries/raw/main/libbitsandbytes_cpu.dll
)
@IF NOT EXIST %~dp0temp\libbitsandbytes_cuda116.dll (
    @CALL %~dp0got --dir %~dp0temp https://github.com/geocine/dreamstall-binaries/raw/main/libbitsandbytes_cuda116.dll 
)
@IF NOT EXIST %~dp0temp\main.py (
    @CALL %~dp0got --dir %~dp0temp https://github.com/geocine/dreamstall-binaries/raw/main/main.py
)
@CALL copy %~dp0temp\*.dll %~dp0root\envs\diffusers\Lib\site-packages\bitsandbytes\
@CALL copy %~dp0temp\cextension.py %~dp0root\envs\diffusers\Lib\site-packages\bitsandbytes\cextension.py
@CALL copy %~dp0temp\main.py %~dp0root\envs\diffusers\Lib\site-packages\bitsandbytes\cuda_setup\main.py
@CALL "%~dp0update.bat"
@CALL pause

@IF NOT EXIST %~dp0temp\cudnn_windows.zip (
	@CALL %~dp0got --dir %~dp0temp https://huggingface.co/datasets/geocine/dreamstall/resolve/bin/cudnn_windows.zip
	REM Originally from https://developer.nvidia.com/compute/cudnn/secure/8.6.0/local_installers/11.8/cudnn-windows-x86_64-8.6.0.163_cuda11-archive.zip
)
@IF NOT EXIST %~dp0temp\cudnn_windows (
	@CALL unzip %~dp0temp\cudnn_windows.zip -d %~dp0temp\cudnn_windows
	@CALL copy %~dp0temp\cudnn_windows\* %~dp0root\envs\diffusers\Lib\site-packages\torch\lib
)