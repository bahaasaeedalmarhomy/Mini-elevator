
$ErrorActionPreference = "Stop"

$proteusPath = "C:\ProgramData\Labcenter Electronics\Proteus 8 Professional"

# Locate the HX711 library folder relative to this script
$sourceFolderName = "Electronics-Tree-HX711-Load-Cell-Amplifier-Library"

$matches = Get-ChildItem -Path $PSScriptRoot -Directory -Recurse |
    Where-Object { $_.Name -eq $sourceFolderName }

if ($matches.Count -ne 1) {
    throw "Expected exactly one '$sourceFolderName' folder, found $($matches.Count)."
}

$sourcePath = $matches[0].FullName

foreach ($folder in @("LIB", "MODELS")) {
    $source = Join-Path $sourcePath $folder
    $destination = Join-Path $proteusPath $(
        if ($folder -eq "LIB") { "LIBRARY" } else { "MODELS" }
    )

    if (-not (Test-Path $source)) {
        throw "Source folder not found: $source"
    }

    if (-not (Test-Path $destination)) {
        throw "Proteus destination not found: $destination"
    }

    Copy-Item -Path (Join-Path $source "*") `
        -Destination $destination -Recurse -Force

    Write-Host "Copied $folder files successfully." -ForegroundColor Green
}

Write-Host "`nHX711 installation completed!" -ForegroundColor Green
