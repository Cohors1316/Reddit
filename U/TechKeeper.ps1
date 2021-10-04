# https://www.reddit.com/r/PowerShell/comments/pzvtej/assistance_with_exit_functionality/
Param (

    # AD
    [System.String]
    $SearchBase,

    # Days
    [System.String]
    $OlderThan

)

$StaleUsers = Get-ADUser -Filter * -SearchBase $SearchBase -Properties 'LastLogOnDate' |
Where-Object -FilterScript {($_.LastLogOnDate -LE (Get-Date).AddDays(-$OlderThan)) -And ($_.Enabled -Eq $True)} |
Select-Object -Property Name, SamAccountName
If ($StaleUsers) {

    Write-Host -Object $StaleUsers.Name
    $Documents = [System.Environment]::GetFolderPath('MyDocuments')
    Export-Csv -Path $Documents\StaleUsers\List.csv -InputObject $StaleUsers -NoClobber
    Exit 1001

} Else {

    Write-Host -Object 'No stale users found'

}
