$Env:MAMBA_ROOT_PREFIX = "$PSScriptRoot\..\root"
if ($env:CONDA_DEFAULT_ENV -eq "diffusers") {
    Write-Host "diffusers environment already active"
} else {
    $Env:MAMBA_EXE = "$PSScriptRoot\..\bin\micromamba.exe"
    (& "$PSScriptRoot\..\bin\micromamba.exe" 'shell' 'hook' -s 'powershell' -p "$PSScriptRoot\..\root") | Out-String | Invoke-Expression
    micromamba activate diffusers
}