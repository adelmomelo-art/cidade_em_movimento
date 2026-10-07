$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "=================================================="
Write-Host " CIDADE EM MOVIMENTO - REPARO UTF8"
Write-Host "=================================================="

$cp1252 = [System.Text.Encoding]::GetEncoding(1252)
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$files = Get-ChildItem ".\lib" -Recurse -Filter "*.dart"

$fixedCount = 0

foreach ($file in $files) {

    $text = [System.IO.File]::ReadAllText(
        $file.FullName,
        [System.Text.Encoding]::UTF8
    )

    $hasMojibake =
        ($text.IndexOf([char]0x00C3) -ge 0) -or
        ($text.IndexOf([char]0x00C2) -ge 0) -or
        ($text.IndexOf([char]0x00E2) -ge 0)

    if ($hasMojibake) {

        $bytes = $cp1252.GetBytes($text)

        $fixed = [System.Text.Encoding]::UTF8.GetString($bytes)

        [System.IO.File]::WriteAllText(
            $file.FullName,
            $fixed,
            $utf8NoBom
        )

        Write-Host "CORRIGIDO: $($file.FullName)"
        $fixedCount++
    }
}

Write-Host ""
Write-Host "Arquivos corrigidos: $fixedCount"
Write-Host "=================================================="