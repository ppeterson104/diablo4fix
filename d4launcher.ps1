
#Set installed flag to false
$d4Installed = $false
$d4Exe = ""
$d4RegPath = ""

#Get OS Architecture to determine 32 or 64 bit registry paths
if ((Get-WmiObject win32_operatingsystem | Select-Object osarchitecture).osarchitecture -like "64*") {

  $d4RegPath = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Diablo IV"

} else {

  $d4RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Diablo IV"

}

function checkD4Prefs {


  # Pass in the $d4PrefsPath
  param (
  [string]
  $prefsPath
  )

  Write-Host "Running the D4 prefs check..."
  Write-Host ""

  # Get the content of the LocalPrefs.txt file
  $checkDisplayVals = Get-Content -Path $prefsPath

  $matchString = 'DisplayMode(Height|Width) "[0-9]+"'

  # RegEx match replace for the DisplayModeWidth and DisplayModeHeight values
  $checkDisplayVals = $checkDisplayVals | ForEach-Object { $_ -replace $matchString, ""}

  #Set the content of the LocalPrefs.txt file with removed values
  Set-Content -Path $prefsPath -Value $checkDisplayVals

  #Re-check for success:
  $checkDisplayVals = Get-Content -Path $prefsPath

  $checkVerify = $checkDisplayVals | Where-Object { $_ -match $matchString }

  if ($checkVerify -ne $null) {

    return $false

  } else {


    return $true

  }

}

Write-Host "Checking for D4 installation... " -NoNewline
#Check for D4 installation
if (Test-Path $d4RegPath) {

  Write-Host "Success!" -ForegroundColor Green
  Write-Host ""

  #Get Exe path:
  $d4Data = Get-ItemProperty $d4RegPath

  $d4InstallPath = $d4Data.InstallLocation

  $appName = $d4Data.DisplayName + ".exe"

  $d4Exe = "$d4InstallPath\$appName"

  #Set installed flag to true
  $d4Installed = $true

}


if ($d4Installed) {

#Get Default Docs path
$userDocs = [Environment]::GetFolderPath("MyDocuments")

Write-Host "My Documents path detected as: $userDocs"
Write-Host ""

#Create path to the LocalPrefs.txt file
$d4PrefsPath = "$userDocs\Diablo IV\LocalPrefs.txt"

if (Test-Path $d4PrefsPath) {

  $d4FileCheck = checkD4Prefs -prefsPath $d4PrefsPath

  if ($d4FileCheck) {

    Write-Host "DisplayMode data successfully removed. Launching Diablo IV!"

    Start-Process -FilePath $d4Exe

  } else {

    Write-Host "Failed to remove DisplayMode data!"
    Write-Host ""
    Write-Host "Closing script..."
    Start-Sleep -Seconds 5
  }

} else {

  Write-Warning "LocalPrefs.txt file not found in expected location! Closing..."

  Start-Sleep -Seconds 5

}


} else {

  Write-Host "Failed" -NoNewline -ForegroundColor Red

  Write-Host ""

  Write-Warning "Diablo IV installation not detected! Closing..."

  Start-Sleep -Seconds 5

}