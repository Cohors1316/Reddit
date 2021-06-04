# Don't remember how exactly this came to be

<#
Start-Process -FilePath PowerShell -ArgumentList "-ExecutionPolicy Bypass -NoProfile -File $ThisPS1" -Verb RunAs # -Verb RunAs only needed if it needs admin priv
or if using a powershell shortcut
-ExecutionPolicy Bypass -NoProfile -File Path\To\This.ps1
#>

Param (

    [Parameter(Mandatory)]
    [System.String]
    $ExcelSheet = 'C:\EmailProject\Excel.xlsx',

    [Parameter(Mandatory)]
    [System.String]
    $UserName = 'username',

    [Parameter(Mandatory)]
    [System.String]
    $Domain = 'domain.com',

    [Parameter(Mandatory)]
    [System.String]
    $Folder = 'folder'

)

$FolderPath = "\\$UserName@$Domain\Inbox\$Folder"

#Get emails
$Inbox = (New-Object -ComObject Outlook.Application).GetNameSpace("MAPI").GetDefaultFolder(6)
$Emails = $Inbox.Folders.Where({$_.FolderPath -Eq $FolderPath}).Items
$Path = [System.IO.Directory]::GetParent($ExcelSheet).FullName

#Download attachments
ForEach ($Email In $Emails) {

    $Timestamp = ([System.DateTime]::Parse($Email.ReceivedTime)).ToString('yyyyMMddhhmmss')
    ForEach ($Attachment In $Email.Attachments) {

        $FileName = $Attachment.FileName
        $FileName = $FileName.Insert($FileName.IndexOf('.'),$Timestamp)
        $FileName = [System.IO.Path]::ChangeExtension($FileName, '.csv')
        $FileName = [System.IO.Path]::Combine($Path, $FileName)
        $Attachment.SaveAsFile($FileName)

    }

}

$Array = [System.Collections.Generic.List[System.Object]]::New()
$Path = [System.IO.Directory]::GetParent($ExcelSheet).FullName
ForEach ($File In (Get-ChildItem -Path $Path -Filter *.csv)) {

    $Csv = Import-Csv -Path $File.FullName
    $Array.Add($Csv)
    Remove-Item  -Path $File.FullName -Confirm:$false -Force

}

$Array | Select-Object -ExpandProperty SyncRoot | Export-Csv -Path "$Path\Merged.csv"

Start-Process -FilePath $ExcelSheet
