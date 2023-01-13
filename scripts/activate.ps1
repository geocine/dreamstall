$Env:MAMBA_ROOT_PREFIX = "$PSScriptRoot\..\root"
$Env:MAMBA_EXE = "$PSScriptRoot\..\bin\micromamba.exe"
(& "$PSScriptRoot\..\bin\micromamba.exe" 'shell' 'hook' -s 'powershell' -p "$PSScriptRoot\..\root") | Out-String | Invoke-Expression
micromamba activate diffusers