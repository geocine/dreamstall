@SET BIN_DIR=%~dp0..\bin
@SET CONFIG_DIR=%~dp0..\configs
@SET BASE_DIR= %~dp0..
@SET TEMP_DIR=%~dp0..\temp
@SET ROOT_DIR=%~dp0..\root
@SET XFORMERS_URL=https://github.com/geocine/dreamstall-binaries/releases/download/c116-p310-t112/xformers-0.0.14.dev0-cp310-cp310-win_amd64.whl
@SET DIFFUSERS_URL=diffusers

@CALL mkdir root
@CALL "%BIN_DIR%\micromamba.exe" create -n diffusers python=3.10 -c conda-forge -r "%ROOT_DIR%" -y
@IF "%CONDA_DEFAULT_ENV%" == "diffusers" (
    echo diffusers environment already active
) ELSE (
    @CALL "%BIN_DIR%\micromamba.exe" shell init --shell=cmd.exe --prefix="%ROOT_DIR%"
    CALL "%ROOT_DIR%condabin\micromamba.bat" activate diffusers
)
@CALL pip install torch==1.12.1+cu116 torchvision==0.13.1+cu116 --extra-index-url https://download.pytorch.org/whl/cu116
@CALL pip install pytorch_lightning
@CALL pip install -U %DIFFUSERS_URL%
@CALL pip install -U -r %BASE_DIR%\requirements.txt
@CALL pip install -U -I --no-deps %XFORMERS_URL%
@CALL python %~dp0setup.py