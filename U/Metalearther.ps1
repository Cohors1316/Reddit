# https://www.reddit.com/r/PowerShell/comments/mdpsap/help_with_parsing_a_powershell_script/

Get-ADUser -Filter {EmployeeID -Like '*'} -Properties EmployeeID, Mail |
Where-Object {$_.Enabled -Eq $True} |
Select-Object @{
    Label='DisplayName'
    Expression={ $_.Surname, $_.GivenName -Join ', ' }
}, @{
    Label='Email'
    Expression={$_.Mail}
}, @{
    Label='EmployeeID'
    Expression={$_.EmployeeID}
} | Export-Csv -Path C:\MVWC-Script\EnabledWithEmp.csv -NoTypeInformation
