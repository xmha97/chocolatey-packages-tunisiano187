﻿$ErrorActionPreference = 'Stop'
$installerType 			= 'MSI'
$url 					= 'https://downloads.citrix.com/7110/ShareFileSync32_v3.24.106.0.msi?__gda__=1598876779_51df14cd9649b49c663362bb6f0bc6a2'
$checksum 				= 'dcf05efb9b81ae50fb6d0b0cd6b983866ab79d93544c48ed8c010fef0f0d09ed'
$checksumType 			= 'sha256'
$url64 					= 'https://downloads.citrix.com/7110/ShareFileSync64_v3.24.106.0.msi?__gda__=1598876779_af8dd3d560d30426a7f328252abea25d'
$checksum64 			= '4a4d085d22f6743b84f766d91395dd0b4e0ba2a2963257c1851e4ce7fbadec1c'
$checksumType64 		= 'sha256'
$silentArgs 			= '/quiet'
$validExitCodes 		= @(0)

$releases 				= 'https://www.citrix.com/downloads/sharefile/clients-and-plug-ins/sharefile-sync-for-windows.html'
$urls					=$(((Invoke-WebRequest -Uri $releases -UseBasicParsing).Links | Where-Object {$_.rel -match '.msi'}).rel)
$url 					= "https:$($urls[0])"
$url64 					= "https:$($urls[1])"

$packageArgs = @{
	packageName   		= $env:ChocolateyPackageName
	fileType      		= $installerType
	url           		= $url
	checksum      		= $checksum
	checksumType  		= $checksumType
	url64          		= $url64
	checksum64     		= $checksum64
	checksumType64 		= $checksumType64
	silentArgs    		= $silentArgs
	validExitCodes		= $validExitCodes
}

Install-ChocolateyPackage @packageArgs
