Import-Module au
Import-Module PowerShellForGitHub

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition)
. $currentPath\helpers.ps1

$toolsPath = Join-Path -Path $currentPath -ChildPath 'tools'
$softwareRepo = 'pavel-a/ddverpatch'

function global:au_GetLatest {
    return Get-LatestVersionInfo
}

function global:au_BeforeUpdate ($Package) {
    Get-RemoteFiles -Purge -NoSuffix -Algorithm sha256

    Copy-Item -Path "$toolsPath\VERIFICATION.txt.template" -Destination "$toolsPath\VERIFICATION.txt" -Force

    Set-DescriptionFromReadme -Package $Package -ReadmePath '.\DESCRIPTION.md'
}

function global:au_AfterUpdate ($Package) {
    $licenseUri = "https://raw.githubusercontent.com/$($softwareRepo)/master/LICENSE"
    $licenseContents = Invoke-WebRequest -Uri $licenseUri -UseBasicParsing

    Set-Content -Path 'tools\LICENSE.txt' -Value "From: $licenseUri`r`n`r`n$licenseContents"
}

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            '(<packageSourceUrl>)[^<]*(</packageSourceUrl>)' = "`$1https://github.com/brogers5/chocolatey-package-$($Latest.PackageName)/tree/v$($Latest.Version)`$2"
            '(<licenseUrl>)[^<]*(</licenseUrl>)'             = "`$1https://github.com/$($softwareRepo)/blob/master/LICENSE`$2"
            '(<projectSourceUrl>)[^<]*(</projectSourceUrl>)' = "`$1https://github.com/$($softwareRepo)/tree/$($Latest.SoftwareVersion)`$2"
            '(<releaseNotes>)[^<]*(</releaseNotes>)'         = "`$1https://github.com/$($softwareRepo)/blob/$($Latest.SoftwareVersion)/verpatch-ReadMe.txt`$2"
            '(<copyright>)[^<]*(</copyright>)'               = "`$1Copyright (c) 1999, 2020, $((Get-Date).Year) Pavel A.`$2"
        }
        'tools\VERIFICATION.txt'        = @{
            '%checksumValue%'   = "$($Latest.Checksum32)"
            '%checksumType%'    = "$($Latest.ChecksumType32.ToUpper())"
            '%tagReleaseUrl%'   = "https://github.com/$($softwareRepo)/releases/tag/$($Latest.SoftwareVersion)"
            '%archiveUrl%'      = "$($Latest.Url32)"
            '%archiveFileName%' = "$($Latest.FileName32)"
        }
        'tools\chocolateyinstall.ps1'   = @{
            "(^[$]archiveFileName\s*=\s*)('.*')" = "`$1'$($Latest.FileName32)'"
        }
    }
}

Update-Package -ChecksumFor None -NoReadme
