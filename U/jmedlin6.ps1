# https://www.reddit.com/r/PowerShell/comments/nrplxo/datagridview/
# didn't write it, just fixing reddit's mess of the code.

$CertGrid = [System.Windows.Forms.DataGridView]::New()
$CertGrid.width = 1275
$CertGrid.height = 450
$CertGrid.location = [System.Drawing.Point]::New(20,20)
$CertGrid.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$CertGrid.TabIndex = 1
$CertGrid.add_CurrentCellDirtyStateChanged($CertGrid_CurrentCellDirtyStateChanged)
$CertGrid.RowHeadersVisible = $True
$CertGrid.defaultCellStyle.wrapMode = [System.Windows.Forms.DataGridViewTriState]::True
$CertGrid.AutoSizeRowsMode = [System.Windows.Forms.DataGridViewAutoSizeRowsMode]::AllCells
$CertGrid.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::AllCells
$CertGrid.AllowUserToDeleteRows = $True
$CertGrid.AutoGenerateColumns = $True
