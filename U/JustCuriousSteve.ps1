# https://www.reddit.com/r/PowerShell/comments/njoh1g/copyitem/

$TargetFolder = 'C:\Users\Public\pix'
$Target = Get-ChildItem -Path $TargetFolder -Filter capt*.jpg
$Source = Get-ChildItem -Path //10.10.1.120/pix -Filter capt*.jpg -Recurse -File |
Where-Object -FilterScript {$_.LastWriteTime.Date -Eq [System.DateTime]::Now.Date}
ForEach ($File In $Source) {
    $TargetFile = $Target.Where({$_.Name -Eq $File.Name})
    If (-Not $TargetFile) {$Copy = $True}
    ElseIf ($File.LastWriteTime -NE $TargetFile.LastWriteTime) {$Copy = $True}
    Else {$Copy = $False}
    If ($Copy) {Copy-Item -Path $File.FullName -Destination $TargetFolder\$($TargetFile.Name) -Force -Confirm:$False}
}
