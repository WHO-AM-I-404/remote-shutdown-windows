#Requires -RunAsAdministrator

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host " AUTO REMOTE SHUTDOWN ENABLER - Windows 10/11" -ForegroundColor Yellow
Write-Host " by WHO-AM-I" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

# Langkah 1: Aktifkan File & Printer Sharing dan Network Discovery
Write-Host "`n[LANGKAH 1] Mengaktifkan Network Sharing..." -ForegroundColor Green
Set-NetConnectionProfile -NetworkCategory Private -ErrorAction SilentlyContinue
Set-NetFirewallRule -DisplayGroup "File and Printer Sharing" -Enabled True -Profile Private -ErrorAction SilentlyContinue
Set-NetFirewallRule -DisplayGroup "Network Discovery" -Enabled True -Profile Private -ErrorAction SilentlyContinue

# Langkah 2: Nonaktifkan kebijakan password untuk akun lokal
Write-Host "`n[LANGKAH 2] Menyesuaikan Kebijakan Keamanan..." -ForegroundColor Green
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "LimitBlankPasswordUse" -Value 0 -Force

# Beri hak remote shutdown untuk semua user
Write-Host "Memberikan hak remote shutdown untuk semua user..." -ForegroundColor Yellow
$secTemplate = @"
[Unicode]
Unicode=yes
[Version]
signature="`$CHICAGO`$"
revision=1
[Privilege Rights]
SeRemoteShutdownPrivilege = *S-1-1-0
"@
$templatePath = "$env:TEMP\sec_temp.inf"
$secTemplate | Out-File -FilePath $templatePath -Encoding unicode
secedit /configure /db secedit.sdb /cfg $templatePath /areas USER_RIGHTS | Out-Null
Remove-Item $templatePath -Force

# Langkah 3: Aktifkan Remote Registry Service
Write-Host "`n[LANGKAH 3] Mengaktifkan Remote Registry..." -ForegroundColor Green
Set-Service -Name RemoteRegistry -StartupType Automatic
Start-Service -Name RemoteRegistry -ErrorAction SilentlyContinue

# Langkah 4: Atur firewall untuk remote shutdown
Write-Host "`n[LANGKAH 4] Mengkonfigurasi Firewall..." -ForegroundColor Green
$ruleName = "RemoteShutdown-Inbound-TCP"
if (-not (Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule -DisplayName $ruleName `
        -Direction Inbound `
        -Protocol TCP `
        -LocalPort 135,445,139 `
        -RemotePort Any `
        -Action Allow `
        -Enabled True `
        -Profile Private | Out-Null
}

# Langkah 5: Tampilkan alamat IP laptop
Write-Host "`n[LANGKAH 5] Mendapatkan Alamat IP..." -ForegroundColor Green
$ipAddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {
    $_.InterfaceAlias -notmatch "Loopback|Virtual|Bluetooth" -and 
    $_.IPAddress -notmatch '^169\.254' -and
    $_.IPAddress -match '^\d+\.\d+\.\d+\.\d+$'
}).IPAddress | Select-Object -First 1

Write-Host "`n========================================================" -ForegroundColor Green
Write-Host "ALAMAT IP TARGET: $ipAddress" -ForegroundColor Yellow -BackgroundColor Black
Write-Host "========================================================" -ForegroundColor Green

# Langkah 6: Buat shortcut untuk remote shutdown
Write-Host "`n[LANGKAH 6] Membuat Shortcut di Desktop..." -ForegroundColor Green
$desktopPath = [Environment]::GetFolderPath("Desktop")
$shutdownShortcut = "$desktopPath\RemoteShutdown.lnk"
$restartShortcut = "$desktopPath\RemoteRestart.lnk"
$targetPath = "C:\Windows\System32\shutdown.exe"
$iconLocation = "$targetPath,0"

# Buat shortcut untuk shutdown
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shutdownShortcut)
$shortcut.TargetPath = $targetPath
$shortcut.Arguments = "/s /m \\$ipAddress /t 0"
$shortcut.IconLocation = $iconLocation
$shortcut.Description = "Remote Shutdown untuk $ipAddress"
$shortcut.Save()

# Buat shortcut untuk restart
$restart = $shell.CreateShortcut($restartShortcut)
$restart.TargetPath = $targetPath
$restart.Arguments = "/r /m \\$ipAddress /t 0"
$restart.IconLocation = $iconLocation
$restart.Description = "Remote Restart untuk $ipAddress"
$restart.Save()

# Langkah 7: Buat file petunjuk penggunaan
$guidePath = "$desktopPath\Petunjuk Remote.txt"
$guideContent = @"
========================================================
PANDUAN PENGGUNAAN REMOTE SHUTDOWN/RESTART
========================================================

1. DARI PC WINDOWS LAIN (dalam jaringan sama):
   - Buka Command Prompt
   - Untuk SHUTDOWN ketik:
        shutdown /s /m \\$ipAddress /t 0
   - Untuk RESTART ketik:
        shutdown /r /m \\$ipAddress /t 0

2. DARI ANDROID (Termux):
   a. Install Termux: https://termux.dev
   b. Buka Termux dan ketik:
        pkg update && pkg install busybox
        busybox shutdown -r -f -t 0 now \\$ipAddress
   (Untuk shutdown ganti '-r' dengan '-s')

3. DARI SHORTCUT DI DESKTOP:
   - Klik 'RemoteShutdown.lnk' untuk mematikan PC
   - Klik 'RemoteRestart.lnk' untuk restart PC

CATATAN PENTING:
- Pastikan PC target dan perangkat pengendali dalam jaringan WiFi yang sama
- Untuk akun tanpa password, pastikan Anda menggunakan Microsoft Account
- Jika gagal, coba matikan Windows Defender Firewall sementara

IP TARGET: $ipAddress
Terakhir dikonfigurasi: $(Get-Date -Format "yyyy-MM-dd HH:mm")
"@

$guideContent | Out-File -FilePath $guidePath -Encoding utf8

Write-Host "`n========================================================" -ForegroundColor Green
Write-Host "KONFIGURASI SUKSES!" -ForegroundColor Yellow
Write-Host "========================================================" -ForegroundColor Green
Write-Host "Berikut telah dibuat di desktop Anda:" -ForegroundColor Cyan
Write-Host "1. RemoteShutdown.lnk    - Shortcut untuk shutdown" -ForegroundColor White
Write-Host "2. RemoteRestart.lnk     - Shortcut untuk restart" -ForegroundColor White
Write-Host "3. Petunjuk Remote.txt   - Panduan lengkap penggunaan" -ForegroundColor White

Write-Host "`nTekan Enter untuk keluar..." -ForegroundColor DarkGray
[Console]::ReadKey($true) | Out-Null
