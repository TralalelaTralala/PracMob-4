$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$projectRoot = Split-Path -Parent $PSScriptRoot
$evidenceRoot = Join-Path $projectRoot 'evidence'
$screenshotsRoot = Join-Path $evidenceRoot 'screenshots'
New-Item -ItemType Directory -Force -Path $screenshotsRoot | Out-Null

function Get-WrappedLines {
    param(
        [string]$Text,
        [System.Drawing.Graphics]$Graphics,
        [System.Drawing.Font]$Font,
        [single]$MaxWidth
    )

    $result = [System.Collections.Generic.List[string]]::new()
    foreach ($sourceLine in ($Text -replace "`t", '    ').Split("`n")) {
        $line = $sourceLine.TrimEnd("`r")
        if ($line.Length -eq 0) {
            $result.Add('')
            continue
        }

        $current = ''
        foreach ($word in ($line -split '\s+')) {
            $candidate = if ($current.Length -eq 0) { $word } else { "$current $word" }
            if ($Graphics.MeasureString($candidate, $Font).Width -le $MaxWidth) {
                $current = $candidate
                continue
            }

            if ($current.Length -gt 0) {
                $result.Add($current)
                $current = ''
            }

            if ($Graphics.MeasureString($word, $Font).Width -le $MaxWidth) {
                $current = $word
                continue
            }

            $fragment = ''
            foreach ($character in $word.ToCharArray()) {
                $candidateFragment = $fragment + $character
                if ($fragment.Length -gt 0 -and $Graphics.MeasureString($candidateFragment, $Font).Width -gt $MaxWidth) {
                    $result.Add($fragment)
                    $fragment = [string]$character
                } else {
                    $fragment = $candidateFragment
                }
            }
            $current = $fragment
        }

        if ($current.Length -gt 0) {
            $result.Add($current)
        }
    }

    return ,$result.ToArray()
}

function New-TerminalEvidencePng {
    param(
        [string]$Path,
        [string]$Title,
        [string]$Command,
        [string]$Output,
        [string]$Footer = 'Captured from a successful local run; output shown from evidence transcript.'
    )

    $width = 1800
    $padding = 64
    $outputWidth = $width - ($padding * 2) - 48
    $bitmap = [System.Drawing.Bitmap]::new($width, 300)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

    $titleFont = [System.Drawing.Font]::new('Segoe UI', 22, [System.Drawing.FontStyle]::Bold)
    $labelFont = [System.Drawing.Font]::new('Segoe UI', 12, [System.Drawing.FontStyle]::Bold)
    $monoFont = [System.Drawing.Font]::new('Consolas', 19, [System.Drawing.FontStyle]::Regular)
    $smallFont = [System.Drawing.Font]::new('Segoe UI', 10, [System.Drawing.FontStyle]::Regular)
    $textBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(230, 237, 243))
    $mutedBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(139, 148, 158))
    $accentBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(88, 166, 255))
    $panelBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(13, 17, 23))
    $headerBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(22, 27, 34))
    $borderPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(48, 54, 61), 1)

    try {
        $lines = Get-WrappedLines -Text $Output -Graphics $graphics -Font $monoFont -MaxWidth $outputWidth
        $lineHeight = 31
        $height = 300 + ($lines.Count * $lineHeight)
        $graphics.Dispose()
        $bitmap.Dispose()
        $bitmap = [System.Drawing.Bitmap]::new($width, $height)
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
        $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

        $graphics.Clear([System.Drawing.Color]::FromArgb(8, 12, 18))
        $graphics.FillRectangle($headerBrush, 0, 0, $width, 84)
        $graphics.FillRectangle($accentBrush, 0, 0, 8, $height)
        $graphics.DrawString('PracMob4  /  Console evidence', $titleFont, $textBrush, 36, 24)
        $graphics.DrawString($Title, $labelFont, $accentBrush, $width - 420, 34)

        $graphics.DrawString('COMMAND', $labelFont, $mutedBrush, $padding, 110)
        $graphics.DrawString("PS C:\PracMob4> $Command", $monoFont, $textBrush, $padding, 136)

        $panelY = 190
        $panelHeight = $height - $panelY - 44
        $graphics.FillRectangle($panelBrush, $padding, $panelY, $width - ($padding * 2), $panelHeight)
        $graphics.DrawRectangle($borderPen, $padding, $panelY, $width - ($padding * 2), $panelHeight)
        $graphics.FillRectangle($headerBrush, $padding, $panelY, $width - ($padding * 2), 42)
        $graphics.FillEllipse([System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 95, 86)), $padding + 18, $panelY + 15, 12, 12)
        $graphics.FillEllipse([System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 189, 46)), $padding + 40, $panelY + 15, 12, 12)
        $graphics.FillEllipse([System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(39, 201, 63)), $padding + 62, $panelY + 15, 12, 12)
        $graphics.DrawString('Program output', $smallFont, $mutedBrush, $padding + 98, $panelY + 12)

        $y = $panelY + 58
        foreach ($line in $lines) {
            if ($line.Length -gt 0) {
                $graphics.DrawString($line, $monoFont, $textBrush, $padding + 24, $y)
            }
            $y += $lineHeight
        }
        $graphics.DrawString($Footer, $smallFont, $mutedBrush, $padding, $height - 31)
        $bitmap.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    }
    finally {
        $graphics.Dispose()
        $bitmap.Dispose()
        $titleFont.Dispose()
        $labelFont.Dispose()
        $monoFont.Dispose()
        $smallFont.Dispose()
        $textBrush.Dispose()
        $mutedBrush.Dispose()
        $accentBrush.Dispose()
        $panelBrush.Dispose()
        $headerBrush.Dispose()
        $borderPen.Dispose()
    }
}

$tasks = @(
    @{ Name = 'task1_variables'; Title = 'Task 1  /  Variables & Types'; Command = 'dart run bin/task1_variables.dart' },
    @{ Name = 'task2_functions'; Title = 'Task 2  /  Functions'; Command = 'dart run bin/task2_functions.dart' },
    @{ Name = 'task3_classes'; Title = 'Task 3  /  OOP University System'; Command = 'dart run bin/task3_classes.dart' },
    @{ Name = 'task4_collections'; Title = 'Task 4  /  Collections & Data'; Command = 'dart run bin/task4_collections.dart' },
    @{ Name = 'task5_async'; Title = 'Task 5  /  Async Processing'; Command = 'dart run bin/task5_async.dart' }
)

foreach ($task in $tasks) {
    $transcriptPath = Join-Path $evidenceRoot "$($task.Name)_output.txt"
    $transcript = [System.IO.File]::ReadAllText($transcriptPath, [System.Text.Encoding]::UTF8).TrimEnd([char[]]@("`r", "`n"))
    $imagePath = Join-Path $screenshotsRoot "$($task.Name).png"
    New-TerminalEvidencePng -Path $imagePath -Title $task.Title -Command $task.Command -Output $transcript -Footer 'Rendered from the saved stdout transcript; not a raw desktop capture.'
}

$quality = @(
    'PS C:\PracMob4> dart analyze',
    (Get-Content (Join-Path $evidenceRoot 'analysis.txt') -Raw).Trim(),
    '',
    'PS C:\PracMob4> dart run test/models_test.dart',
    (Get-Content (Join-Path $evidenceRoot 'models_tests.txt') -Raw).Trim(),
    '',
    'PS C:\PracMob4> dart run test/utils_test.dart',
    (Get-Content (Join-Path $evidenceRoot 'utils_tests.txt') -Raw).Trim()
) -join "`n"
New-TerminalEvidencePng -Path (Join-Path $screenshotsRoot 'quality_checks.png') -Title 'Quality checks  /  Analyzer & tests' -Command 'dart analyze' -Output $quality -Footer 'Rendered from saved analyzer and test transcripts; not a raw desktop capture.'
