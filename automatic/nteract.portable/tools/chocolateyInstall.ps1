﻿$packageName= $env:ChocolateyPackageName

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$softwareDir  = "$toolsDir/nteract"
$softwareExe  = "$softwareDir/nteract.exe"

$url          = 'https://github.com/nteract/nteract/releases/download/v0.25.1/nteract-0.25.1-win.zip'
$checksum     = '75572f71c5a50f478715189177c1cb0f7a558b41225651434366410a94016ae0'
$checksumType = 'sha256'

$packageArgs = @{
  PackageName   = $packageName
  Url           = $url
  UnzipLocation = $toolsDir
  ChecksumType  = $checksumType
  Checksum      = $checksum
}

Install-ChocolateyZipPackage @packageArgs

 # Rename unzipped folder
Rename-Item "$toolsDir\win-unpacked" "$softwareDir"

# Don't create shims for anything other than main exe
$files = get-childitem "$toolsDir" -include *.exe -exclude 'nteract.exe' -recurse
foreach ($file in $files) {
  New-Item "$file.ignore" -type file -force | Out-Null
}

# Create desktop shortcut
$desktop = $([System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::DesktopDirectory))
$link = Join-Path $desktop 'nteract.lnk'
if (!(Test-Path $link)) {
    Install-ChocolateyShortcut -ShortcutFilePath "$link" -TargetPath "$softwareExe" -WorkingDirectory "$softwareDir"
}

# Associate file extension
Install-ChocolateyFileAssociation -Extension '.ipynb' -Executable "$softwareExe"


# Install ipykernel to get started directly
Start-ChocolateyProcessAsAdmin "&python -m pip install ipykernel"
Start-ChocolateyProcessAsAdmin "&python -m ipykernel install --user"