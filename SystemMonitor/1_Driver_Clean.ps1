# SCRIPT RUN AS ADMIN
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
{
    Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit
}

$Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " (Administrator)"
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.PrivateData.ProgressBackgroundColor = "Black"
$Host.PrivateData.ProgressForegroundColor = "White"
Clear-Host

if ($env:SAFEBOOT_OPTION) {
    Write-Host "Driver Clean is disabled in Safe Mode. Please reboot normally before running this script." -ForegroundColor Yellow
    Pause
    exit 1
}

# SCRIPT CHECK INTERNET
if (!(Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet -ErrorAction SilentlyContinue)) {
    Write-Host "Internet Connection Required`n" -ForegroundColor Red
    Pause
    exit
}

$ProgressPreference = 'SilentlyContinue'

Clear-Host

# =========================
# AUTO MODE ONLY
# =========================

# Install 7-Zip
Write-Host "Installing: 7-Zip File Manager`n"

IWR "https://github.com/FR33THYFR33THY/Ultimate-Files/raw/refs/heads/main/7zip.exe" -OutFile "$env:SystemRoot\Temp\7zip.exe"
Start-Process -Wait "$env:SystemRoot\Temp\7zip.exe" -ArgumentList "/S"

cmd /c "reg add `"HKEY_CURRENT_USER\Software\7-Zip\Options`" /v `"ContextMenu`" /t REG_DWORD /d `"259`" /f >nul 2>&1"
cmd /c "reg add `"HKEY_CURRENT_USER\Software\7-Zip\Options`" /v `"CascadedMenu`" /t REG_DWORD /d `"0`" /f >nul 2>&1"

Move-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\7-Zip\7-Zip File Manager.lnk" `
-Destination "$env:ProgramData\Microsoft\Windows\Start Menu\Programs" -Force -ErrorAction SilentlyContinue | Out-Null

Remove-Item "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\7-Zip" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null

# Download DDU
Write-Host "Downloading: Display Driver Uninstaller`n"

IWR "https://github.com/FR33THYFR33THY/Ultimate-Files/raw/refs/heads/main/ddu.exe" -OutFile "$env:SystemRoot\Temp\ddu.exe"

& "$env:SystemDrive\Program Files\7-Zip\7z.exe" x "$env:SystemRoot\Temp\ddu.exe" -o"$env:SystemRoot\Temp\ddu" -y | Out-Null

# DDU config
$DduConfig = @'
<?xml version="1.0" encoding="utf-8"?>
<DisplayDriverUninstaller Version="18.1.4.2">
    <Settings>
        <SelectedLanguage>en-US</SelectedLanguage>
        <RemoveMonitors>True</RemoveMonitors>
        <RemoveCrimsonCache>True</RemoveCrimsonCache>
        <RemoveAMDDirs>True</RemoveAMDDirs>
        <RemoveAudioBus>True</RemoveAudioBus>
        <RemoveAMDKMPFD>True</RemoveAMDKMPFD>
        <RemoveNvidiaDirs>True</RemoveNvidiaDirs>
        <RemovePhysX>True</RemovePhysX>
        <RemoveGFE>True</RemoveGFE>
        <RemoveVulkan>True</RemoveVulkan>
        <PreventWinUpdate>True</PreventWinUpdate>
    </Settings>
</DisplayDriverUninstaller>
'@

Set-Content -Path "$env:SystemRoot\Temp\ddu\Settings\Settings.xml" -Value $DduConfig -Force
Set-ItemProperty -Path "$env:SystemRoot\Temp\ddu\Settings\Settings.xml" -Name IsReadOnly -Value $true

cmd /c "reg add `"HKLM\Software\Microsoft\Windows\CurrentVersion\DriverSearching`" /v `"SearchOrderConfig`" /t REG_DWORD /d `"0`" /f >nul 2>&1"

# Create AUTO DDU script
$DDU = @'
# SCRIPT RUN AS ADMIN
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
{
    Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit
}

$Host.UI.RawUI.WindowTitle = "DDU AUTO (Administrator)"
Clear-Host

cmd /c "bcdedit /deletevalue {current} safeboot >nul 2>&1"

Write-Host "Running DDU..." -ForegroundColor Red

Start-Process "$env:SystemRoot\Temp\ddu\Display Driver Uninstaller.exe" -ArgumentList "-CleanAllGpus -Restart" -Wait
'@

Set-Content -Path "$env:SystemRoot\Temp\ddu.ps1" -Value $DDU -Force

cmd /c "reg add `"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce`" /v `"*ddu`" /t REG_SZ /d `"powershell.exe -nop -ep bypass -WindowStyle Maximized -f $env:SystemRoot\Temp\ddu.ps1`" /f >nul 2>&1"

cmd /c "bcdedit /set {current} safeboot minimal >nul 2>&1"

Write-Host "Restarting..." -ForegroundColor Red
Start-Sleep -Seconds 5
shutdown -r -t 0
