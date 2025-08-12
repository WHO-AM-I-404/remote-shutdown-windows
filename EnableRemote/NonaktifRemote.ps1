#Requires -RunAsAdministrator

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host " DISABLE REMOTE SHUTDOWN - Windows 10/11" -ForegroundColor Yellow
Write-Host " by DeepSeek-R1" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

# Langkah 1: Nonaktifkan File & Printer Sharing dan Network Discovery
Write-Host "`n[LANGKAH 1] Menonaktifkan Network Sharing..." -ForegroundColor Green
Set-NetFirewallRule -DisplayGroup "File and Printer Sharing" -Enabled False -Profile Private -ErrorAction SilentlyContinue
Set-NetFirewallRule -DisplayGroup "Network Discovery" -Enabled False -Profile Private -ErrorAction SilentlyContinue

# Langkah 2: Aktifkan kembali kebijakan password untuk akun lokal
Write-Host "`n[LANGKAH 2] Mengembalikan Kebijakan Keamanan..." -ForegroundColor Green
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "LimitBlankPasswordUse" -Value 1 -Force

# Cabut hak remote shutdown untuk semua user
Write-Host "Mencabut hak remote shutdown..." -ForegroundColor Yellow
$secTemplate = @"
[Unicode]
Unicode=yes
[Version]
signature="`$CHICAGO`$"
revision=1
[Privilege Rights]
SeRemoteShutdownPrivilege = 
"@
$templatePath = "$env:TEMP\sec_temp_disable.inf"
$secTemplate | Out-File -FilePath $templatePath -Encoding unicode
secedit /configure /db secedit.sdb /cfg $templatePath /areas USER_RIGHTS | Out-Null
Remove-Item $templatePath -Force

# Langkah 3: Nonaktifkan Remote Registry Service
Write-Host "`n[LANGKAH 3] Menonaktifkan Remote Registry..." -ForegroundColor Green
Stop-Service -Name RemoteRegistry -Force -ErrorAction SilentlyContinue
Set-Service -Name RemoteRegistry -StartupType Disabled

# Langkah 4: Hapus aturan firewall khusus
Write-Host "`n[LANGKAH 4] Menghapus Rule Firewall..." -ForegroundColor Green
$ruleName = "RemoteShutdown-Inbound-TCP"
if (Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue) {
    Remove-NetFirewallRule -DisplayName $ruleName -Confirm:$false | Out-Null
}

# Langkah 5: Hapus shortcut dan panduan
Write-Host "`n[LANGKAH 5] Membersihkan Desktop..." -ForegroundColor Green
$desktopPath = [Environment]::GetFolderPath("Desktop")
$itemsToRemove = @(
    "RemoteShutdown.lnk",
    "RemoteRestart.lnk",
    "Petunjuk Remote.txt"
)

foreach ($item in $itemsToRemove) {
    $fullPath = Join-Path -Path $desktopPath -ChildPath $item
    if (Test-Path $fullPath) {
        Remove-Item $fullPath -Force
        Write-Host "Dihapus: $item" -ForegroundColor Yellow
    }
}

# Langkah 6: Reset pengaturan sharing default
Write-Host "`n[LANGKAH 6] Mereset Pengaturan Sharing Default..." -ForegroundColor Green
Set-NetConnectionProfile -NetworkCategory Public -ErrorAction SilentlyContinue
Set-NetFirewallProfile -Profile Public -Enabled True -ErrorAction SilentlyContinue

Write-Host "`n========================================================" -ForegroundColor Green
Write-Host " SEMUA FITUR REMOTE ACCESS TELAH DINONAKTIFKAN!" -ForegroundColor Yellow
Write-Host "========================================================" -ForegroundColor Green
Write-Host "Berikut perubahan yang dilakukan:" -ForegroundColor Cyan
Write-Host "- File & Printer Sharing dinonaktifkan" -ForegroundColor White
Write-Host "- Network Discovery dimatikan" -ForegroundColor White
Write-Host "- Kebijakan password diperketat" -ForegroundColor White
Write-Host "- Hak remote shutdown dicabut" -ForegroundColor White
Write-Host "- Remote Registry Service dimatikan" -ForegroundColor White
Write-Host "- Rule firewall dihapus" -ForegroundColor White
Write-Host "- Shortcut dan panduan dihapus" -ForegroundColor White

Write-Host "`nTekan Enter untuk keluar..." -ForegroundColor DarkGray
[Console]::ReadKey($true) | Out-Null
