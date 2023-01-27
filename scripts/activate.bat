@SET MAMBA_ROOT_PREFIX=%~dp0..\root
@IF "%CONDA_DEFAULT_ENV%" == "diffusers" (
    echo diffusers environment already active
) ELSE (
    @CALL "%~dp0..\root\condabin\micromamba.bat" activate diffusers
)
