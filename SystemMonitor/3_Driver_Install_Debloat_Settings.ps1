# SCRIPT RUN AS ADMIN
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
{Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
Exit}
$Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " (Administrator)"
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.PrivateData.ProgressBackgroundColor = "Black"
$Host.PrivateData.ProgressForegroundColor = "White"
Clear-Host

# SCRIPT CHECK INTERNET
if (!(Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet -ErrorAction SilentlyContinue)) {
    Write-Host "Internet Connection Required`n" -ForegroundColor Red
    Pause
    exit
}

# SCRIPT SILENT
$progressPreference = 'silentlycontinue'

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Show-GPUSelectionDialog {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Select your GPU'
    $form.Size = New-Object System.Drawing.Size(380,220)
    $form.StartPosition = 'CenterScreen'
    $form.FormBorderStyle = 'FixedDialog'
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false

    $label = New-Object System.Windows.Forms.Label
    $label.Text = "SELECT YOUR SYSTEM'S GPU"
    $label.AutoSize = $true
    $label.Font = New-Object System.Drawing.Font('Segoe UI',12,[System.Drawing.FontStyle]::Bold)
    $label.Location = New-Object System.Drawing.Point(24,20)
    $form.Controls.Add($label)

    $nvidiaButton = New-Object System.Windows.Forms.Button
    $nvidiaButton.Text = 'NVIDIA'
    $nvidiaButton.Size = New-Object System.Drawing.Size(100,36)
    $nvidiaButton.Location = New-Object System.Drawing.Point(24,70)
    $nvidiaButton.Add_Click({ $form.Tag = 1; $form.Close() })
    $form.Controls.Add($nvidiaButton)

    $amdButton = New-Object System.Windows.Forms.Button
    $amdButton.Text = 'AMD'
    $amdButton.Size = New-Object System.Drawing.Size(100,36)
    $amdButton.Location = New-Object System.Drawing.Point(134,70)
    $amdButton.Add_Click({ $form.Tag = 2; $form.Close() })
    $form.Controls.Add($amdButton)

    $intelButton = New-Object System.Windows.Forms.Button
    $intelButton.Text = 'INTEL'
    $intelButton.Size = New-Object System.Drawing.Size(100,36)
    $intelButton.Location = New-Object System.Drawing.Point(244,70)
    $intelButton.Add_Click({ $form.Tag = 3; $form.Close() })
    $form.Controls.Add($intelButton)

    $form.ShowDialog() | Out-Null
    return $form.Tag
}

$choice = Show-GPUSelectionDialog
if (-not $choice) {
    Write-Host 'No GPU selected. Exiting.' -ForegroundColor Yellow
    exit
}

Clear-Host

if ($choice -eq 1) {
    Write-Host "DOWNLOAD NVIDIA GPU DRIVER`n" -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    Start-Process "https://www.nvidia.com/en-us/drivers"
    Pause
    Clear-Host

    Write-Host "SELECT DOWNLOADED DRIVER`n" -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    Add-Type -AssemblyName System.Windows.Forms
    $Dialog = New-Object System.Windows.Forms.OpenFileDialog
    $Dialog.Filter = "All Files (*.*)|*.*"
    $Dialog.ShowDialog() | Out-Null
    $InstallFile = $Dialog.FileName

    Write-Host "DEBLOATING DRIVER`n"
    & "$env:SystemDrive\Program Files\7-Zip\7z.exe" x "$InstallFile" -o"$env:SystemRoot\Temp\nvidiadriver" -y | Out-Null

    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\Display.Nview" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\FrameViewSDK" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\HDAudio" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\MSVCRT" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\NvApp.MessageBus" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\NvBackend" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\NvContainer" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\NvCpl" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\NvDLISR" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\NVPCF" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\NvTelemetry" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\NvVAD" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\PhysX" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\PPC" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\ShadowPlay" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\NvApp\CEF" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\NvApp\osc" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\NvApp\Plugins" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\NvApp\UpgradeConsent" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\NvApp\www" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\NvApp\7z.dll" -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\NvApp\7z.exe" -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\NvApp\DarkModeCheck.exe" -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\NvApp\InstallerExtension.dll" -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\NvApp\NvApp.nvi" -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\NvApp\NvAppApi.dll" -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\NvApp\NvAppExt.dll" -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemRoot\Temp\nvidiadriver\NvApp\NvConfigGenerator.dll" -Force -ErrorAction SilentlyContinue | Out-Null

    Write-Host "INSTALLING DRIVER`n"
    Start-Process "$env:SystemRoot\Temp\nvidiadriver\setup.exe" -ArgumentList "-s -noreboot -noeula -clean" -Wait -NoNewWindow

    try {
        Start-Process "winget" -ArgumentList "install `"9NF8H0H7WMLT`" --silent --accept-package-agreements --accept-source-agreements --disable-interactivity --no-upgrade" -Wait -WindowStyle Hidden
    } catch { }

    Get-AppxPackage -allusers *Microsoft.Winget.Source* | Remove-AppxPackage -ErrorAction SilentlyContinue
    Remove-Item "$InstallFile" -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemDrive\NVIDIA" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null

    $subkeys = Get-ChildItem -Path "Registry::HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" -Force -ErrorAction SilentlyContinue
    foreach($key in $subkeys){
        if ($key -notlike '*Configuration'){
            reg add "$key" /v "DisableDynamicPstate" /t REG_DWORD /d "1" /f | Out-Null
        }
    }

    $subkeys = Get-ChildItem -Path "Registry::HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" -Force -ErrorAction SilentlyContinue
    foreach($key in $subkeys){
        if ($key -notlike '*Configuration'){
            reg add "$key" /v "RMHdcpKeyglobZero" /t REG_DWORD /d "1" /f | Out-Null
        }
    }

    $path = "C:\ProgramData\NVIDIA Corporation\Drs"
    Get-ChildItem -Path $path -Recurse | Unblock-File

    cmd /c "reg add `"HKLM\System\ControlSet001\Services\nvlddmkm\Parameters\Global\NVTweak`" /v `"NvCplPhysxAuto`" /t REG_DWORD /d `"0`" /f >nul 2>&1"
    cmd /c "reg add `"HKLM\System\ControlSet001\Services\nvlddmkm\Parameters\Global\NVTweak`" /v `"NvDevToolsVisible`" /t REG_DWORD /d `"1`" /f >nul 2>&1"

    $subkeys = Get-ChildItem -Path "Registry::HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" -Force -ErrorAction SilentlyContinue
    foreach($key in $subkeys){
        if ($key -notlike '*Configuration'){
            reg add "$key" /v "RmProfilingAdminOnly" /t REG_DWORD /d "0" /f | Out-Null
        }
    }
    cmd /c "reg add `"HKLM\System\ControlSet001\Services\nvlddmkm\Parameters\Global\NVTweak`" /v `"RmProfilingAdminOnly`" /t REG_DWORD /d `"0`" /f >nul 2>&1"
    cmd /c "reg add `"HKCU\Software\NVIDIA Corporation\NvTray`" /v `"StartOnLogin`" /t REG_DWORD /d `"0`" /f >nul 2>&1"
    cmd /c "reg add `"HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS`" /v `"EnableGR535`" /t REG_DWORD /d `"0`" /f >nul 2>&1"
    cmd /c "reg add `"HKLM\SYSTEM\ControlSet001\Services\nvlddmkm\Parameters\FTS`" /v `"EnableGR535`" /t REG_DWORD /d `"0`" /f >nul 2>&1"
    cmd /c "reg add `"HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters\FTS`" /v `"EnableGR535`" /t REG_DWORD /d `"0`" /f >nul 2>&1"

    IWR "https://github.com/FR33THYFR33THY/Ultimate-Files/raw/refs/heads/main/inspector.exe" -OutFile "$env:SystemRoot\Temp\inspector.exe"

    $nipfile = @'
<?xml version="1.0" encoding="utf-16"?>
<ArrayOfProfile>
  <Profile>
    <ProfileName>Base Profile</ProfileName>
    <Executables/>
    <Settings>
      <ProfileSetting>
        <SettingNameInfo>Frame Rate Limiter V3</SettingNameInfo>
        <SettingID>277041154</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>GSYNC - Application Mode</SettingNameInfo>
        <SettingID>294973784</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>GSYNC - Application State</SettingNameInfo>
        <SettingID>279476687</SettingID>
        <SettingValue>4</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>GSYNC - Global Feature</SettingNameInfo>
        <SettingID>278196567</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>GSYNC - Global Mode</SettingNameInfo>
        <SettingID>278196727</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>GSYNC - Indicator Overlay</SettingNameInfo>
        <SettingID>268604728</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Maximum Pre-Rendered Frames</SettingNameInfo>
        <SettingID>8102046</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Preferred Refresh Rate</SettingNameInfo>
        <SettingID>6600001</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Ultra Low Latency - CPL State</SettingNameInfo>
        <SettingID>390467</SettingID>
        <SettingValue>2</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Ultra Low Latency - Enabled</SettingNameInfo>
        <SettingID>277041152</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Vertical Sync</SettingNameInfo>
        <SettingID>11041231</SettingID>
        <SettingValue>138504007</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Vertical Sync - Smooth AFR Behavior</SettingNameInfo>
        <SettingID>270198627</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Vertical Sync - Tear Control</SettingNameInfo>
        <SettingID>5912412</SettingID>
        <SettingValue>2525368439</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Vulkan/OpenGL Present Method</SettingNameInfo>
        <SettingID>550932728</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Antialiasing - Gamma Correction</SettingNameInfo>
        <SettingID>276652957</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Antialiasing - Mode</SettingNameInfo>
        <SettingID>276757595</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Antialiasing - Setting</SettingNameInfo>
        <SettingID>282555346</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Anisotropic Filter - Optimization</SettingNameInfo>
        <SettingID>8703344</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Anisotropic Filter - Sample Optimization</SettingNameInfo>
        <SettingID>15151633</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Anisotropic Filtering - Mode</SettingNameInfo>
        <SettingID>282245910</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Anisotropic Filtering - Setting</SettingNameInfo>
        <SettingID>270426537</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Texture Filtering - Negative LOD Bias</SettingNameInfo>
        <SettingID>1686376</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Texture Filtering - Quality</SettingNameInfo>
        <SettingID>13510289</SettingID>
        <SettingValue>20</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Texture Filtering - Trilinear Optimization</SettingNameInfo>
        <SettingID>3066610</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>CUDA - Force P2 State</SettingNameInfo>
        <SettingID>1343646814</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>CUDA - Sysmem Fallback Policy</SettingNameInfo>
        <SettingID>283962569</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Power Management - Mode</SettingNameInfo>
        <SettingID>274197361</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Shader Cache - Cache Size</SettingNameInfo>
        <SettingID>11306135</SettingID>
        <SettingValue>4294967295</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Threaded Optimization</SettingNameInfo>
        <SettingID>549528094</SettingID>
        <SettingValue>1</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>OpenGL GDI Compatibility</SettingNameInfo>
        <SettingID>544392611</SettingID>
        <SettingValue>0</SettingValue>
        <ValueType>Dword</ValueType>
      </ProfileSetting>
      <ProfileSetting>
        <SettingNameInfo>Preferred OpenGL GPU</SettingNameInfo>
        <SettingID>550564838</SettingID>
        <SettingValue>id,2.0:268410DE,00000100,GF - (400,2,161,24564) @ (0)</SettingValue>
        <ValueType>String</ValueType>
      </ProfileSetting>
    </Settings>
  </Profile>
</ArrayOfProfile>
'@
Set-Content -Path "$env:SystemRoot\Temp\inspector.nip" -Value $nipfile -Force

Start-Process -wait "$env:SystemRoot\Temp\inspector.exe" -ArgumentList "-silentImport -silent $env:SystemRoot\Temp\inspector.nip"

    break
} elseif ($choice -eq 2) {
    Clear-Host

    Write-Host "DOWNLOAD AMD GPU DRIVER`n" -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    Start-Process "https://www.amd.com/en/support/download/drivers.html"
    Pause
    Clear-Host

    Write-Host "SELECT DOWNLOADED DRIVER`n" -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    Add-Type -AssemblyName System.Windows.Forms
    $Dialog = New-Object System.Windows.Forms.OpenFileDialog
    $Dialog.Filter = "All Files (*.*)|*.*"
    $Dialog.ShowDialog() | Out-Null
    $InstallFile = $Dialog.FileName

    Write-Host "DEBLOATING DRIVER`n"
    & "$env:SystemDrive\Program Files\7-Zip\7z.exe" x "$InstallFile" -o"$env:SystemRoot\Temp\amddriver" -y | Out-Null

    $xmlFiles = @(
        "$env:SystemRoot\Temp\amddriver\Config\AMDAUEPInstaller.xml"
        "$env:SystemRoot\Temp\amddriver\Config\AMDCOMPUTE.xml"
        "$env:SystemRoot\Temp\amddriver\Config\AMDLinkDriverUpdate.xml"
        "$env:SystemRoot\Temp\amddriver\Config\AMDRELAUNCHER.xml"
        "$env:SystemRoot\Temp\amddriver\Config\AMDScoSupportTypeUpdate.xml"
        "$env:SystemRoot\Temp\amddriver\Config\AMDUpdater.xml"
        "$env:SystemRoot\Temp\amddriver\Config\AMDUWPLauncher.xml"
        "$env:SystemRoot\Temp\amddriver\Config\EnableWindowsDriverSearch.xml"
        "$env:SystemRoot\Temp\amddriver\Config\InstallUEP.xml"
        "$env:SystemRoot\Temp\amddriver\Config\ModifyLinkUpdate.xml"
    )
    foreach ($file in $xmlFiles) {
        if (Test-Path $file) {
            $content = Get-Content $file -Raw
            $content = $content -replace '<Enabled>true</Enabled>', '<Enabled>false</Enabled>'
            $content = $content -replace '<Hidden>true</Hidden>', '<Hidden>false</Hidden>'
            Set-Content $file -Value $content -NoNewline
        }
    }

    $jsonFiles = @(
        "$env:SystemRoot\Temp\amddriver\Config\InstallManifest.json"
        "$env:SystemRoot\Temp\amddriver\Bin64\cccmanifest_64.json"
    )
    foreach ($file in $jsonFiles) {
        if (Test-Path $file) {
            $content = Get-Content $file -Raw
            $content = $content -replace '"InstallByDefault"\s*:\s*"Yes"', '"InstallByDefault" : "No"'
            Set-Content $file -Value $content -NoNewline
        }
    }

    Write-Host "INSTALLING DRIVER`n"
    Start-Process -Wait "$env:SystemRoot\Temp\amddriver\Bin64\ATISetup.exe" -ArgumentList "-INSTALL -VIEW:2" -WindowStyle Hidden

    cmd /c "reg delete `"HKCU\Software\Microsoft\Windows\CurrentVersion\Run`" /v `"AMDNoiseSuppression`" /f >nul 2>&1"
    cmd /c "reg delete `"HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce`" /v `"StartRSX`" /f >nul 2>&1"
    Unregister-ScheduledTask -TaskName "StartCN" -Confirm:$false -ErrorAction SilentlyContinue
    cmd /c "sc stop `"AMD Crash Defender Service`" >nul 2>&1"
    cmd /c "sc delete `"AMD Crash Defender Service`" >nul 2>&1"
    cmd /c "sc stop `"amdfendr`" >nul 2>&1"
    cmd /c "sc delete `"amdfendr`" >nul 2>&1"
    cmd /c "sc stop `"amdfendrmgr`" >nul 2>&1"
    cmd /c "sc delete `"amdfendrmgr`" >nul 2>&1"
    cmd /c "sc stop `"amdacpbus`" >nul 2>&1"
    cmd /c "sc delete `"amdacpbus`" >nul 2>&1"
    cmd /c "sc stop `"AMDSAFD`" >nul 2>&1"
    cmd /c "sc delete `"AMDSAFD`" >nul 2>&1"
    cmd /c "sc stop `"AtiHDAudioService`" >nul 2>&1"
    cmd /c "sc delete `"AtiHDAudioService`" >nul 2>&1"
    Remove-Item "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\AMD Bug Report Tool" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemDrive\Windows\SysWOW64\AMDBugReportTool.exe" -Force -ErrorAction SilentlyContinue | Out-Null

    $findamdinstallmanager = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
    $amdinstallmanager = Get-ItemProperty $findamdinstallmanager -ErrorAction SilentlyContinue |
        Where-Object { $_.DisplayName -like "*AMD Install Manager*" }
    if ($amdinstallmanager) {
        $guid = $amdinstallmanager.PSChildName
        Start-Process "msiexec.exe" -ArgumentList "/x $guid /qn /norestart" -Wait -NoNewWindow
    }

    Remove-Item "$InstallFile" -Force -ErrorAction SilentlyContinue | Out-Null
    $folderName = "AMD Software$([char]0xA789) Adrenalin Edition"
    Move-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\$folderName\$folderName.lnk" -Destination "$env:ProgramData\Microsoft\Windows\Start Menu\Programs" -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\$folderName" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:SystemDrive\AMD" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null

    Write-Host "IMPORTING SETTINGS"
    Write-Host "IGNORE RSSERVCMD.EXE ERROR`n" -ForegroundColor Red
    Start-Process "$env:SystemDrive\Program Files\AMD\CNext\CNext\RadeonSoftware.exe"
    Start-Sleep -Seconds 15
    Stop-Process -Name "RadeonSoftware" -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    cmd /c "reg add `"HKCU\Software\AMD\CN`" /v `"AutoUpdate`" /t REG_DWORD /d `"0`" /f >nul 2>&1"
    cmd /c "reg add `"HKCU\Software\AMD\CN`" /v `"WizardProfile`" /t REG_SZ /d `"PROFILE_CUSTOM`" /f >nul 2>&1"

    $basePath = "HKLM:\System\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}"
    $allKeys = Get-ChildItem -Path $basePath -Recurse -ErrorAction SilentlyContinue
    $optionKeys = $allKeys | Where-Object { $_.PSChildName -eq "UMD" }
    foreach ($key in $optionKeys) {
        $regPath = $key.Name
        cmd /c "reg add `"$regPath`" /v `"VSyncControl`" /t REG_BINARY /d `"3000`" /f >nul 2>&1"
    }
    $allKeys = Get-ChildItem -Path $basePath -Recurse -ErrorAction SilentlyContinue
    $optionKeys = $allKeys | Where-Object { $_.PSChildName -eq "UMD" }
    foreach ($key in $optionKeys) {
        $regPath = $key.Name
        cmd /c "reg add `"$regPath`" /v `"TFQ`" /t REG_BINARY /d `"3200`" /f >nul 2>&1"
    }
    $allKeys = Get-ChildItem -Path $basePath -Recurse -ErrorAction SilentlyContinue
    $optionKeys = $allKeys | Where-Object { $_.PSChildName -eq "UMD" }
    foreach ($key in $optionKeys) {
        $regPath = $key.Name
        cmd /c "reg add `"$regPath`" /v `"Tessellation`" /t REG_BINARY /d `"3100`" /f >nul 2>&1"
        cmd /c "reg add `"$regPath`" /v `"Tessellation_OPTION`" /t REG_BINARY /d `"3200`" /f >nul 2>&1"
    }
    cmd /c "reg add `"HKCU\Software\AMD\CN\CustomResolutions`" /v `"EulaAccepted`" /t REG_SZ /d `"true`" /f >nul 2>&1"
    cmd /c "reg add `"HKCU\Software\AMD\CN\DisplayOverride`" /v `"EulaAccepted`" /t REG_SZ /d `"true`" /f >nul 2>&1"
    $basePath = "HKLM:\System\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}"
    $allKeys = Get-ChildItem -Path $basePath -Recurse -ErrorAction SilentlyContinue
    $optionKeys = $allKeys | Where-Object { $_.PSChildName -eq "power_v1" }
    foreach ($key in $optionKeys) {
        $regPath = $key.Name
        cmd /c "reg add `"$regPath`" /v `"abmlevel`" /t REG_BINARY /d `"00000000`" /f >nul 2>&1"
    }
    cmd /c "reg add `"HKCU\Software\AMD\CN`" /v `"SystemTray`" /t REG_SZ /d `"false`" /f >nul 2>&1"
    cmd /c "reg add `"HKCU\Software\AMD\CN`" /v `"CN_Hide_Toast_Notification`" /t REG_SZ /d `"true`" /f >nul 2>&1"
    cmd /c "reg add `"HKCU\Software\AMD\CN`" /v `"AnimationEffect`" /t REG_SZ /d `"false`" /f >nul 2>&1"
    cmd /c "reg delete `"HKCU\Software\AMD\CN\Notification`" /f >nul 2>&1"
    cmd /c "reg add `"HKCU\Software\AMD\CN\Notification`" /f >nul 2>&1"
    cmd /c "reg add `"HKCU\Software\AMD\CN\FreeSync`" /v `"AlreadyNotified`" /t REG_DWORD /d `"1`" /f >nul 2>&1"
    cmd /c "reg add `"HKCU\Software\AMD\CN\OverlayNotification`" /v `"AlreadyNotified`" /t REG_DWORD /d `"1`" /f >nul 2>&1"
    cmd /c "reg add `"HKCU\Software\AMD\CN\VirtualSuperResolution`" /v `"AlreadyNotified`" /t REG_DWORD /d `"1`" /f >nul 2>&1"

} elseif ($choice -eq 3) {
    Clear-Host
    Write-Host "DOWNLOAD INTEL GPU DRIVER`n" -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    Start-Process "https://www.intel.com/content/www/us/en/search.html#sortCriteria=%40lastmodifieddt%20descending&f-operatingsystem_en=Windows%2011%20Family*&f-downloadtype=Drivers&cf-tabfilter=Downloads&cf-downloadsppth=Graphics"
    Pause
    Clear-Host

    Write-Host "SELECT DOWNLOADED DRIVER`n" -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    Add-Type -AssemblyName System.Windows.Forms
    $Dialog = New-Object System.Windows.Forms.OpenFileDialog
    $Dialog.Filter = "All Files (*.*)|*.*"
    $Dialog.ShowDialog() | Out-Null
    $InstallFile = $Dialog.FileName

    Write-Host "DEBLOATING DRIVER`n"
    & "$env:SystemDrive\Program Files\7-Zip\7z.exe" x "$InstallFile" -o"$env:SystemDrive\inteldriver" -y | Out-Null

    Write-Host "INSTALLING DRIVER`n"
    Start-Process "cmd.exe" -ArgumentList "/c `"$env:SystemDrive\inteldriver\Installer.exe`" -f --noExtras --terminateProcesses -s" -WindowStyle Hidden -Wait

    $IntelGraphicsSoftware = Get-ChildItem "$env:SystemDrive\inteldriver\Resources\Extras\IntelGraphicsSoftware_*.exe" | Select-Object -First 1 -ExpandProperty Name
    if ($IntelGraphicsSoftware) {
        Start-Process "$env:SystemDrive\inteldriver\Resources\Extras\$IntelGraphicsSoftware" -ArgumentList "/s" -Wait -NoNewWindow
    }

    $FileName = "Intel$([char]0xAE) Graphics Software"
    cmd /c "reg delete `"HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run`" /v `"$FileName`" /f >nul 2>&1"
    cmd /c "sc stop `"IntelGFXFWupdateTool`" >nul 2>&1"
    cmd /c "sc delete `"IntelGFXFWupdateTool`" >nul 2>&1"
    cmd /c "sc stop `"cplspcon`" >nul 2>&1"
    cmd /c "sc delete `"cplspcon`" >nul 2>&1"
    cmd /c "sc stop `"CtaChildDriver`" >nul 2>&1"
    cmd /c "sc delete `"CtaChildDriver`" >nul 2>&1"
    cmd /c "sc stop `"GSCAuxDriver`" >nul 2>&1"
    cmd /c "sc delete `"GSCAuxDriver`" >nul 2>&1"
    cmd /c "sc stop `"GSCx64`" >nul 2>&1"
    cmd /c "sc delete `"GSCx64`" >nul 2>&1"

    $stop = "IntelGraphicsSoftware", "PresentMonService"
    $stop | ForEach-Object { Stop-Process -Name $_ -Force -ErrorAction SilentlyContinue }
    Start-Sleep -Seconds 2
    Remove-Item "$env:SystemDrive\Program Files\Intel\Intel Graphics Software\PresentMonService.exe" -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$InstallFile" -Force -ErrorAction SilentlyContinue | Out-Null
    Move-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Intel\Intel Graphics Software\$FileName.lnk" -Destination "$env:ProgramData\Microsoft\Windows\Start Menu\Programs" -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Intel" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:SystemDrive\Intel" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item "$env:SystemDrive\inteldriver" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null

    $basePath = "HKLM:\System\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}"
    $adapterKeys = Get-ChildItem -Path $basePath -ErrorAction SilentlyContinue
    foreach ($key in $adapterKeys) {
        if ($key.PSChildName -match '^\d{4}$') {
            $regPath = $key.Name
            cmd /c "reg add `"$regPath\3DKeys`" /f >nul 2>&1"
        }
    }

    $allKeys = Get-ChildItem -Path $basePath -Recurse -ErrorAction SilentlyContinue
    $optionKeys = $allKeys | Where-Object { $_.PSChildName -eq "3DKeys" }
    foreach ($key in $optionKeys) {
        $regPath = $key.Name
        cmd /c "reg add `"$regPath`" /v `"Global_AsyncFlipMode`" /t REG_DWORD /d `"2`" /f >nul 2>&1"
    }
    $allKeys = Get-ChildItem -Path $basePath -Recurse -ErrorAction SilentlyContinue
    $optionKeys = $allKeys | Where-Object { $_.PSChildName -eq "3DKeys" }
    foreach ($key in $optionKeys) {
        $regPath = $key.Name
        cmd /c "reg add `"$regPath`" /v `"Global_LowLatency`" /t REG_DWORD /d `"0`" /f >nul 2>&1"
    }
}

Clear-Host
Write-Host "SET" -ForegroundColor Yellow
Write-Host "- SOUND" -ForegroundColor Yellow
Write-Host "- RESOLUTION" -ForegroundColor Yellow
Write-Host "- REFRESH RATE" -ForegroundColor Yellow
Write-Host "- PRIMARY DISPLAY`n" -ForegroundColor Yellow
try {
    Start-Process "ms-settings:display"
} catch { }
try {
    Start-Process shell:appsFolder\NVIDIACorp.NVIDIAControlPanel_56jybvy8sckqj!NVIDIACorp.NVIDIAControlPanel
} catch { }
Start-Process mmsys.cpl
Pause

Clear-Host
$basePath = "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\MonitorDataStore"
$monitorKeys = Get-ChildItem -Path $basePath -Recurse -ErrorAction SilentlyContinue
foreach ($setreg in $monitorKeys) {
    $regPath = $setreg.Name
    cmd /c "reg add `"$regPath`" /v `"AutoColorManagementEnabled`" /t REG_DWORD /d `"0`" /f >nul 2>&1"
}

$gpuDevices = Get-PnpDevice -Class Display
foreach ($gpu in $gpuDevices) {
    $instanceID = $gpu.InstanceId
    cmd /c "reg add `"HKLM\SYSTEM\ControlSet001\Enum\$instanceID\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties`" /v `"MSISupported`" /t REG_DWORD /d `"1`" /f >nul 2>&1"
}

$notifyiconsettings = Get-ChildItem -Path 'registry::HKEY_CURRENT_USER\Control Panel\NotifyIconSettings' -Recurse -Force
foreach ($setreg in $notifyiconsettings) {
    if ((Get-ItemProperty -Path "registry::$setreg").IsPromoted -eq 0) {
    } else {
        Set-ItemProperty -Path "registry::$setreg" -Name 'IsPromoted' -Value 1 -Force
    }
}

Write-Host "RESTARTING`n" -ForegroundColor Red
Start-Sleep -Seconds 5
shutdown -r -t 00
