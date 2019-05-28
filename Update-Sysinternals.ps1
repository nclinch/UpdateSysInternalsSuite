$SysIntPath = 'c:\SysInt'
$File = 'SysinternalsSuite.zip'
$URL = "https://download.sysinternals.com/files/$File"
$FilePath  = "$SysIntPath\$File"


#Create Sysint directory if it doesn't exist
if (!(Test-Path $SysIntPath)){New-Item -Path $SysIntPath -ItemType "directory"}

#Add to Path
if ($Env:path -notlike "*$SysIntPath*") {$Env:path += ";$SysIntPath"}

#Delete Old SysinternalsSuite.zip if it exists
if (Test-Path $FilePath) {Remove-Item $FilePath}


#Download SysinternalsSuite.zip
#Import-Module BitsTransfer


try {
    Start-BitsTransfer -Source $URL -Destination $FilePath 
    #unblock file
    Unblock-File $FilePath 
    #remove old tools
    Get-ChildItem $SysIntPath | where {$_.name -notmatch $File} |Remove-Item
}
catch {
    Write-Output "Unable to download $URL"
}


#Unzip tools
try {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($FilePath, $SysIntPath)
}
catch {
    
    Write-Host "duplicatate file in SysinternalsSuite.zip.`nhttps://social.technet.microsoft.com/Forums/office/en-US/b11309ab-6e10-43f0-bc82-38ca230bfac7/two-dbgview-executables-why?forum=miscutils"
}
