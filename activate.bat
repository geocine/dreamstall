@CALL "%~dp0micromamba.exe" shell init --shell=cmd.exe --prefix="%~dp0root"
start cmd /k "%~dp0root\condabin\micromamba.bat" activate diffusers