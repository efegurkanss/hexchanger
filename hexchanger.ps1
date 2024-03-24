Write-Host "by exec"


$exe_dosyasi = Read-Host "Please enter the location of the target file (for example: C:\path\to\app-name.exe):"

if (-not (Test-Path $exe_dosyasi -PathType Leaf)) {
    Write-Host "The target file was not found."
    exit
}

$eski_hex = Read-Host "Enter the old hex code to be replaced (for example: 91234678989321):"
$yeni_hex = Read-Host "Enter the new hex code (for example: BCE22501488322):"

function HexDuzenle {
    param (
        [string]$dosya,
        [string]$yeniHex,
        [string]$eskiHex
    )
    try {
        $dosyaIcerik = Get-Content -Path $dosya -Encoding Byte -ReadCount 0
        $hexIcerik = [System.BitConverter]::ToString($dosyaIcerik) -replace '-', ''
        $duzenlenmisHex = $hexIcerik -replace $eskiHex, $yeniHex
        $duzenlenmisBytes = [byte[]]::new($duzenlenmisHex.Length / 2)
        for ($i = 0; $i -lt $duzenlenmisHex.Length; $i += 2) {
            $duzenlenmisBytes[$i / 2] = [byte]::Parse($duzenlenmisHex.Substring($i, 2), 'HexNumber')
        }
        [System.IO.File]::WriteAllBytes($dosya, $duzenlenmisBytes)
        Write-Host "Hex code has been changed successfully."
    } catch {
        Write-Host "An error occurred: $_"
    }
}

HexDuzenle -dosya $exe_dosyasi -yeniHex $yeni_hex -eskiHex $eski_hex

Write-Host "Process completed. Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
