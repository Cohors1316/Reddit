<#
https://www.reddit.com/r/PowerShell/comments/nrmeci/i_have_17_csv_files_in_a_folder_and_i_need_to/
#>
$Null = [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
$Null = [System.Reflection.Assembly]::LoadWithPartialName('PresentationFramework')
[System.Windows.Forms.Application]::EnableVisualStyles()

#Define the XAML
[System.Xml.XmlDocument]$MainWindowXaml = @"
<Window 
xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
xmlns:local="clr-namespace:WpfApp2"
Title="CSV Merger" Height="210" Width="525" Topmost="True" WindowStartupLocation="CenterScreen">
<Grid Margin="10,0,0,0">
<TextBox x:Name="tbx_inputpath" HorizontalAlignment="Left" Height="23" Margin="83,57,0,0" TextWrapping="Wrap" Text="Input folder" VerticalAlignment="Top" Width="387"/>
<TextBox x:Name="tbx_outputpath" HorizontalAlignment="Left" Height="23" Margin="83,103,0,0" TextWrapping="Wrap" Text="Output file" VerticalAlignment="Top" Width="387"/>
<Button x:Name="btn_inputbrowse" Content="Browse" HorizontalAlignment="Left" Margin="3,57,0,0" VerticalAlignment="Top" Width="75" Height="23"/>
<Button x:Name="btn_outputbrowse" Content="Browse" HorizontalAlignment="Left" Margin="3,103,0,0" VerticalAlignment="Top" Width="75" Height="23"/>
<Button x:Name="btn_create" Content="Merge" HorizontalAlignment="Left" Margin="195,134,0,0" VerticalAlignment="Top" Width="100" Height="29"/>
<Label x:Name="fhfgh" Content="CSV Merger" HorizontalAlignment="Left" Margin="10,14,0,0" VerticalAlignment="Top" Width="309" FontWeight="Bold"/>
<Label x:Name="lbl_input" Content="Select folder containing .csv files. Note that the folder content will be included." HorizontalAlignment="Left" Margin="83,33,0,0" VerticalAlignment="Top" FontSize="10"/>
<Label x:Name="lbl_output" Content="Select output file" HorizontalAlignment="Left" Margin="83,80,0,0" VerticalAlignment="Top" FontSize="10"/>
</Grid>
</Window>
"@

#Read the XAML
$MainWindowReader = [System.Xml.XmlNodeReader]::New($MainWindowXaml)

#Define the shared runspace hastable
$SyncHash = @{}
$SyncHash.Window = [System.Windows.Markup.XamlReader]::Load($MainWindowReader)

#Add to the hastable
$Nodes = $MainWindowXaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]")
ForEach ($Node In $Nodes) {$SyncHash.Add($Node.Name,$SyncHash.Window.FindName($Node.Name))}

#Input 
$SyncHash.btn_inputbrowse.add_click({

    $FolderBrowser = [System.Windows.Forms.FolderBrowserDialog]::New()
    $FolderBrowser.ShowDialog()

    $SyncHash.tbx_inputpath.Text = $FolderBrowser.SelectedPath

})

#Output
$SyncHash.btn_outputbrowse.add_click({

    $SaveDialog = [System.Windows.Forms.SaveFileDialog]::New()
    $SaveDialog.Title = 'Save CSV as'
    $SaveDialog.Filter = 'CSV files (*.csv)|*.csv'
    $SaveDialog.DefaultExt = 'csv'
    $SaveDialog.OverwritePrompt = $True
    $SaveDialog.ShowDialog()

    $SyncHash.tbx_outputpath.Text = $SaveDialog.FileName

})

#Create
$SyncHash.btn_create.add_click({

    #Get files
    $Data = Get-ChildItem -Path $SyncHash.tbx_inputpath.Text -Filter *.csv | Import-Csv

    #Create the file
    $Data | Export-Csv -Path $SyncHash.tbx_outputpath.Text

    #Close window
    Exit #Realized this was super important as without it the window would remain open, and every time you clicked merge it would merge the new and old ones together again.

})

#Set output to current direcory
$SyncHash.tbx_outputpath.Text = $PSScriptRoot

#Show dialog
$Null = $SyncHash.Window.ShowDialog()
