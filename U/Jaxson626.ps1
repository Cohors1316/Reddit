[CmdletBinding()]

Param (

    [Parameter(ValueFromPipelineByPropertyName)]
    [System.String]
    $ComputerName,

    [Parameter()]
    [System.String]
    $SubKey = 'Control Panel\Keyboard',

    [Parameter()]
    [System.String]
    $ValueName = 'InitialKeyboardIndicators',

    [Parameter()]
    [System.String]
    $Value

)

Begin {

    $Hive = [Microsoft.Win32.RegistryHive]::CurrentUser

} Process {
    
    $Status = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($Hive,$ComputerName).OpenSubKey($SubKey).GetValue($ValueName)
    If ($Status -Eq 0) {
    
        [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($Hive,$ComputerName).OpenSubKey($SubKey,$True).SetValue($ValueName,$Value)
    
    }

} End {

}
