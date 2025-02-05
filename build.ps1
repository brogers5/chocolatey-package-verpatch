$ErrorActionPreference = 'Stop'

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition)
. $currentPath\helpers.ps1

$nuspecFileRelativePath = Join-Path -Path $currentPath -ChildPath 'verpatch.nuspec'

[xml] $nuspec = Get-Content "$nuspecFileRelativePath"
$version = $nuspec.package.metadata.version

$global:Latest = @{
    Url32 = Get-SoftwareUri -Version $version
}

Write-Output 'Downloading...'
Get-RemoteFiles -Purge -NoSuffix

Write-Output 'Creating package...'
choco pack $nuspecFileRelativePath
