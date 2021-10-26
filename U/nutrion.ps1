# https://www.reddit.com/r/PowerShell/comments/qfs9ko/array_is_not_adding_new_entries_and_i_cant_figure/

$List = [System.Collections.Generic.List[System.String]]::New()
ForEach ($Account In $Identity) {
    $User = Get-AdUser -Identity $Account -Properties Name, Mail, Manager
    $List.Add("$($User.Name), $($User.Mail)")

    Do {
        $User = Get-AdUser -Identity $User.Manager -Properties Name, Mail, Manager
        $List.Add("$($User.Name), $($User.Mail)")
    } Until ($Null -Eq $User.Manager)
    $CommaList = $List -Join ', '
}
