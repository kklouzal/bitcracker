$ErrorActionPreference = "Stop"

$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$Build = Join-Path $Root "build"
$Compat = Join-Path $Root "compat"

New-Item -ItemType Directory -Force -Path $Build | Out-Null

function Invoke-Checked {
    param(
        [Parameter(Mandatory = $true)]
        [string] $File,
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]] $Arguments
    )

    & $File @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "$File failed with exit code $LASTEXITCODE"
    }
}

Invoke-Checked cl.exe `
    /nologo /O2 /W3 /I $Compat /D_CRT_SECURE_NO_WARNINGS `
    "/Fe:$Build\bitcracker_hash.exe" `
    "$Root\src_HashExtractor\bitcracker_hash.c"

Invoke-Checked cl.exe `
    /nologo /O2 /W3 /I $Compat /D_CRT_SECURE_NO_WARNINGS `
    "/Fe:$Build\bitcracker_rpgen.exe" `
    "$Root\src_RPGenerator\bitcracker_rpgen.c"

Invoke-Checked nvcc.exe `
    -I $Compat `
    -gencode "arch=compute_89,code=sm_89" `
    -Xcompiler "/O2" `
    -Xcompiler "/D_CRT_SECURE_NO_WARNINGS" `
    -o "$Build\bitcracker_cuda.exe" `
    "$Root\src_CUDA\main.cu" `
    "$Root\src_CUDA\cuda_attack.cu" `
    "$Root\src_CUDA\utils.cu" `
    "$Root\src_CUDA\w_blocks.cu"

Get-ChildItem $Build
