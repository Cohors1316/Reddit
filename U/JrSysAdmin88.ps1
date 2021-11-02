# https://www.reddit.com/r/PowerShell/comments/ql7dyd/how_do_you_update_a_json_file_with_a_csv_import/

$JsonPath = ''
$CsvPath = ''

# Get info
$Json = Get-Content -Path $JsonPath | ConvertFrom-Json
$Csv = Import-Csv -Path $CsvPath

# Get keys
$Users = $Json.PSObject.Properties.Name

# Update json
ForEach ($User In $Users) {
    $Name = $Json.$User.ProfileName
    $Update = $Csv.Where({$_.Profile -Eq $Name})
    If ($Update) {
        If ($Update.Email) {$Json.$User.Email = $Update.Email}
        If ($Update.'Phone Number') {$Json.$User.PhoneNumber = $Update.'Phone Number'}
    }
}

# Save to original file
$Json | 
ConvertTo-Json |
Out-File -FilePath $JsonPath -Force
