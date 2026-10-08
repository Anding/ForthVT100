$ErrorActionPreference = 'Stop'

$repo = Split-Path -Parent $PSScriptRoot
$vfx = Join-Path (Split-Path -Parent $repo) 'VFXForth\Bin\VFXterm.exe'

function Invoke-Presentation([string]$source) {
    Push-Location $repo
    try {
        $stderr = [System.IO.Path]::GetTempFileName()
        $lines = & $vfx $source 2>$stderr
        $exitCode = $LASTEXITCODE
        $errors = Get-Content $stderr -Raw
        Remove-Item $stderr

        if ($exitCode -ne 0) {
            throw "VFXterm exited with $exitCode`n$errors"
        }

        return ($lines -join "`n")
    }
    finally {
        Pop-Location
    }
}

$plain = Invoke-Presentation (Join-Path $PSScriptRoot 'PresentationPlain.f')
$plainBody = [regex]::Match(
    $plain,
    '(?s)@@PRESENTATION-BEGIN\r?\n(.*?)@@PRESENTATION-END'
).Groups[1].Value

if (-not $plainBody) {
    throw 'Plain presentation markers were not found.'
}

if ($plainBody.Contains([char]27)) {
    throw 'Redirected presentation contains an ANSI escape character.'
}

$required = @(
    'Observatory session',
    'CLS is inert',
    'Durable output',
    'Emphasized output',
    'width-controlled wrapping',
    'Diagnostic output',
    'Error output',
    'Cursor controls remain plain',
    '+-- Camera',
    'Model',
    'ASI2600MM Pro',
    '+-Filter',
    '| LUM',
    '| RED'
)

foreach ($text in $required) {
    if (-not $plainBody.Contains($text)) {
        throw "Redirected presentation is missing: $text"
    }
}

if (-not $plainBody.Contains('[ERROR] Error output')) {
    throw 'Redirected error output lost its textual severity.'
}

if (-not $plainBody.Contains('[DEBUG] Diagnostic output')) {
    throw 'Redirected diagnostic output lost its textual severity.'
}

if ($plainBody.Contains('This transient status must not be redirected')) {
    throw 'Transient status leaked into redirected output.'
}

$panel = [regex]::Match(
    $plainBody,
    '(?ms)^(\+-- Camera[^\r\n]*)\r?\n.*?^(\+-+\+)$'
)
if (-not $panel.Success -or
    $panel.Groups[1].Value.Length -ne $panel.Groups[2].Value.Length) {
    throw 'Panel top and bottom borders have different widths.'
}

$terminal = Invoke-Presentation (Join-Path $PSScriptRoot 'PresentationTerminal.f')
$terminalBody = [regex]::Match(
    $terminal,
    '(?s)@@TERMINAL-BEGIN\r?\n(.*?)@@TERMINAL-END'
).Groups[1].Value

if (-not $terminalBody.Contains([char]27)) {
    throw 'Forced terminal presentation did not emit ANSI control.'
}

if (-not $terminalBody.Contains("$([char]27)[36m")) {
    throw 'Terminal table border did not begin with cyan styling.'
}

$terminalText = [regex]::Replace(
    $terminalBody,
    "$([char]27)\[[0-9;?]*[ -/]*[@-~]",
    ''
)

if (-not $terminalText.Contains('[OK] Exposure complete')) {
    throw 'Terminal presentation is missing the success indicator.'
}

$inputSource = Join-Path $PSScriptRoot 'PresentationInput.f'
Push-Location $repo
try {
    $inputOutput = @('." INPUT-SENTINEL" cr', 'bye') |
        & $vfx $inputSource 2>$null |
        Out-String
}
finally {
    Pop-Location
}

if (-not $inputOutput.Contains('INPUT-SENTINEL')) {
    throw 'Redirected countdown consumed command input.'
}

Write-Output 'ForthVT100 presentation tests passed.'
