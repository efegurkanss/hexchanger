Write-Host "by exec"


$exe_dosyasi = Read-Host "Lutfen hedef dosyanin konumunu girin (ornegin: C:\path\to\app-name.exe):"

if (-not (Test-Path $exe_dosyasi -PathType Leaf)) {
    Write-Host "Hedef dosya bulunamadi."
    exit
}

$eski_hex = Read-Host "Degistirilecek eski hex kodunu girin (ornegin: 91234678989321):"
$yeni_hex = Read-Host "Yeni hex kodunu girin (ornegin: BCE22501488322):"

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
        Write-Host "Hex kodu basariyla degistirildi."
    } catch {
        Write-Host "Hata oluştu: $_"
    }
}

HexDuzenle -dosya $exe_dosyasi -yeniHex $yeni_hex -eskiHex $eski_hex

Write-Host "İslem tamamlandi. Devam etmek icin bir tusa basin..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
