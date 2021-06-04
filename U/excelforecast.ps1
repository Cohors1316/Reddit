# https://www.reddit.com/r/PowerShell/comments/nrmeci/i_have_17_csv_files_in_a_folder_and_i_need_to/

$PathToCsvFolder = ''
$OutputPath = 'Output.csv'

$Data = Get-ChildItem -Path $PathToCsvFolder -Fitler *.csv |
Select-Object -Property FullName |
Import-Csv |
Where-Object -Property 'Amount Paid' -Eq 'Y'

$Data | Export-Csv -Path $OutputPath
