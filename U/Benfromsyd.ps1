# https://www.reddit.com/r/PowerShell/comments/nf6quh/how_to_to_check_once_within_a_double_foreach/
# for the record this is probably not the best way to go about this.

$Param = @{
    Header = 'DFS','MessageQueue','ErrorMsg','Ignore','Team','CC','Date','Resend'
    Path = 'C:\temp\messagequeue.csv'
}
$MessageQueue = Import-Csv @Param | Select-Object -Skip 1

$Param = @{
    Header = 'DFS','MessageQueue','ErrorMessage','CreatedDate','StartTime'
    Path = 'C:\temp\file.csv'
}
$SqlFile = Import-Csv @Param | Select-Object -Skip 1

ForEach ($Error In $SqlFile) {
    $Config = $MessageQueue.Where({
        $_.DFS -Match $Error.DFS -And $_.ErrorMsg -Match $Error.ErrorMessage -And $_.MessageQueue -Match $Error.MessageQueue
    })
    Write-Output -InputObject $Config.Team
}
