$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$archiveFileName = 'verpatch-1.0.15.1-x86-codeplex.zip'
$archiveFilePath = Join-Path -Path $toolsDir -ChildPath $archiveFileName

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileFullPath  = $archiveFilePath
}
Get-ChocolateyUnzip @packageArgs

#Clean up 7z archive post-install to prevent unnecessary disk bloat
Remove-Item -Path $archiveFilePath -Force -ErrorAction SilentlyContinue
