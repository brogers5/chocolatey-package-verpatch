Import-Module PowerShellForGitHub

$owner = 'pavel-a'
$repository = 'ddverpatch'

function Get-LatestVersionInfo {
    $releases = Get-GitHubRelease -OwnerName $owner -RepositoryName $repository

    $latestStableRelease = $releases | Where-Object { $_.PreRelease -eq $false } | Select-Object -First 1
    $latestStableVersion = $latestStableRelease.tag_name
    $url32 = Get-SoftwareUriFromReleaseBody -Release $latestStableRelease

    return @{
        SoftwareVersion = $latestStableVersion
        Url32           = $url32
        Version         = $latestStableVersion #This may change if building a package fix version
    }
}

function Get-SoftwareUriFromReleaseBody($Release) {
    $uriPattern = 'https?:\/\/[^)]+'

    if ($Release.body -notmatch $uriPattern) {
        throw 'Cannot find published Windows archive asset!'
    }

    return $Matches[0]
}

function Get-SoftwareUri($Version) {
    $release = Get-GitHubRelease -OwnerName $owner -RepositoryName $repository -Tag "$($Version.ToString())"

    return Get-SoftwareUriFromReleaseBody -Release $release
}
