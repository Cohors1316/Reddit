# https://www.reddit.com/r/PowerShell/comments/nrplxo/datagridview/

$CertGrid = New-Object system.Windows.Forms.DataGridView
$CertGrid.width = 1275
$CertGrid.height = 450
$CertGrid.location = New-Object System.Drawing.Point(20,20)
$CertGrid.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$CertGrid.TabIndex = 1
$CertGrid.add_CurrentCellDirtyStateChanged($CertGrid_CurrentCellDirtyStateChanged)
$CertGrid.RowHeadersVisible = $TRUE
$CertGrid.defaultCellStyle.wrapMode = [System.Windows.Forms.DataGridViewTriState]::True
$CertGrid.AutoSizeRowsMode = [System.Windows.Forms.DataGridViewAutoSizeRowsMode]::AllCells
$CertGrid.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::AllCells
$CertGrid.AllowUserToDeleteRows = $TRUE
$CertGrid.AutoGenerateColumns = $TRUE
