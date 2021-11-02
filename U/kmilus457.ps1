# https://www.reddit.com/r/PowerShell/comments/qkokvx/ping_script_help/

Set-StrictMode -Version 3.0
$ErrorActionPreference = 'Stop'

$Csv = 'Path to file'

$List = ('8.8.8.8','1.1.1.1')

$Result = If ($PSVersionTable.PSEdition -Eq 'Core') {

    ForEach ($Ip In $List) {
        $Test = Test-Connection -TargetName $Ip -Count 1
        $Test | Add-Member -MemberType NoteProperty -Name Date -Value (Get-Date)
        $Test = $Test | Select-Object -Property Date, Address, Status
        Write-Output -InputObject $Test
    }

} Else {

    ForEach ($Ip In $List) {
        Try {
            $Test = Test-Connection -ComputerName $Ip -Count 1
            $Test | Add-Member -MemberType NoteProperty -Name Date -Value (Get-Date)
            $Test = $Test | Select-Object -Property Date, Address, ResponseTime
            Write-Output -InputObject $Test
        } Catch {
            $Test = [PSCustomObject] @{
                Date = Get-Date
                Address = $Ip
                ResponseTime = 'Failed'
            }
            Write-Output -InputObject $Test
        }
    }

}

$Result | Export-Csv -Path $Csv -Append -Force
