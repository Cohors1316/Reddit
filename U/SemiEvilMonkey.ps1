# https://www.reddit.com/r/PowerShell/comments/qnlk0j/getwindows_features_parsed_to_table/

Get-WindowsFeature |
Where-Object -FilterScript {$_.InstallState -Eq 'Installed'} |
Select-Object -Property Name, DisplayName, Subfeatures |
ForEach-Object -Process {
    Write-Output -InputObject ([PSCustomObject]@{
        DisplayName = $_.DisplayName
        Name = $_.Name
        Subfeatures = $_.Subfeatures -Join ','
    })
}
