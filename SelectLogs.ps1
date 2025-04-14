Add-Type -AssemblyName System.Windows.Forms
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

$regPath = "HKCU:\Software\SelectLogs"
if (-not (Test-Path $regPath)) {
    New-Item -Path "HKCU:\Software" -Name "SelectLogs" | Out-Null
}
$destProp = Get-ItemProperty -Path $regPath -Name "Destination" -ErrorAction SilentlyContinue
$global:Election = if ($destProp) { $destProp.Destination } else { "" }

$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Log Collector"
$Form.Size = New-Object System.Drawing.Size(650,480)
$Form.StartPosition = "CenterScreen"
$Form.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$Form.FormBorderStyle = 'FixedDialog'
$Form.MaximizeBox = $false
$Form.MinimizeBox = $false
$Form.BackColor = [System.Drawing.Color]::White

# Machine Selection
$grpMachine = New-Object System.Windows.Forms.GroupBox
$grpMachine.Text = "Machine Selection"
$grpMachine.Location = New-Object System.Drawing.Point(10,10)
$grpMachine.Size = New-Object System.Drawing.Size(610,70)
$Form.Controls.Add($grpMachine)

$lblMachine = New-Object System.Windows.Forms.Label
$lblMachine.Text = "Machine Name:"
$lblMachine.Location = New-Object System.Drawing.Point(10,30)
$lblMachine.Size = New-Object System.Drawing.Size(100,20)
$grpMachine.Controls.Add($lblMachine)

$TextBox = New-Object System.Windows.Forms.TextBox
$TextBox.Location = New-Object System.Drawing.Point(120,28)
$TextBox.Size = New-Object System.Drawing.Size(340,22)
$grpMachine.Controls.Add($TextBox)

$btnShowLogs = New-Object System.Windows.Forms.Button
$btnShowLogs.Text = "Show Logs"
$btnShowLogs.Location = New-Object System.Drawing.Point(470,26)
$btnShowLogs.Size = New-Object System.Drawing.Size(120,25)
$grpMachine.Controls.Add($btnShowLogs)

# Logs
$grpLogs = New-Object System.Windows.Forms.GroupBox
$grpLogs.Text = "Available Services"
$grpLogs.Location = New-Object System.Drawing.Point(10,90)
$grpLogs.Size = New-Object System.Drawing.Size(610,260)
$Form.Controls.Add($grpLogs)

$DataGridView = New-Object System.Windows.Forms.DataGridView
$DataGridView.Location = New-Object System.Drawing.Point(10,20)
$DataGridView.Size = New-Object System.Drawing.Size(590,230)
$DataGridView.ColumnCount = 1
$DataGridView.Columns[0].Name = "Service Name"
$DataGridView.SelectionMode = 'FullRowSelect'
$DataGridView.MultiSelect = $true
$DataGridView.AutoSizeColumnsMode = 'Fill'
$grpLogs.Controls.Add($DataGridView)

# Actions
$grpActions = New-Object System.Windows.Forms.GroupBox
$grpActions.Text = "Actions"
$grpActions.Location = New-Object System.Drawing.Point(10,360)
$grpActions.Size = New-Object System.Drawing.Size(610,60)
$Form.Controls.Add($grpActions)

$btnDestination = New-Object System.Windows.Forms.Button
$btnDestination.Text = "Set Destination"
$btnDestination.Location = New-Object System.Drawing.Point(10,20)
$btnDestination.Size = New-Object System.Drawing.Size(140,25)
$grpActions.Controls.Add($btnDestination)

$btnCopy = New-Object System.Windows.Forms.Button
$btnCopy.Text = "Copy Selected Logs"
$btnCopy.Location = New-Object System.Drawing.Point(160,20)
$btnCopy.Size = New-Object System.Drawing.Size(160,25)
$grpActions.Controls.Add($btnCopy)

$lblStatus = New-Object System.Windows.Forms.Label
$lblStatus.Text = "Destination: " + $global:Election
$lblStatus.AutoEllipsis = $true
$lblStatus.Location = New-Object System.Drawing.Point(330,23)
$lblStatus.Size = New-Object System.Drawing.Size(260,20)
$grpActions.Controls.Add($lblStatus)

# Show Logs
$btnShowLogs.Add_Click({
    $global:machineName = $TextBox.Text.Trim()
    if (-not $global:machineName) {
        [System.Windows.Forms.MessageBox]::Show("Please enter a machine name.", "Missing Info", "OK", "Warning")
        return
    }

    $logPath = "\\$global:machineName\c$\ProgramData\Dalet\DaletLogs"
    try {
        $folders = Get-ChildItem -Path $logPath -Directory -ErrorAction Stop
        $DataGridView.Rows.Clear()
        foreach ($folder in $folders) {
            $DataGridView.Rows.Add($folder.Name)
        }
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Could not access logs at: $logPath", "Access Error", "OK", "Error")
    }
})

# Set Destination
$btnDestination.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($folderBrowser.ShowDialog() -eq "OK") {
        $global:Election = $folderBrowser.SelectedPath
        Set-ItemProperty -Path $regPath -Name "Destination" -Value $global:Election
        $lblStatus.Text = "Destination: " + $global:Election
    }
})

# Copy Logs
$btnCopy.Add_Click({
    if (-not $global:Election) {
        [System.Windows.Forms.MessageBox]::Show("Please select a destination first.", "Missing Info", "OK", "Warning")
        return
    }

    $todayDate = (Get-Date).ToString("yyyyMMdd")
    $destination = Join-Path -Path $global:Election -ChildPath "$todayDate\$global:machineName"
    if (-not (Test-Path $destination)) {
        New-Item -Path $destination -ItemType Directory -Force | Out-Null
    }

    foreach ($selectedRow in $DataGridView.SelectedRows) {
        $serviceName = $selectedRow.Cells[0].Value
        $fullFolderName = (Get-ChildItem -Path "\\$global:machineName\c$\ProgramData\Dalet\DaletLogs" -Directory |
            Where-Object { $_.Name -like "*$serviceName*" }).FullName
        if ($fullFolderName) {
            $destFolder = Join-Path -Path $destination -ChildPath $serviceName
            Copy-Item -Path $fullFolderName -Destination $destFolder -Recurse -Force
        }
    }

    Invoke-Item $destination
})

# Mostrar ventana y evitar mensaje "Cancel"
$Form.ShowDialog() | Out-Null
exit


# Set Destination
$btnDestination.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($folderBrowser.ShowDialog() -eq "OK") {
        $global:Election = $folderBrowser.SelectedPath
        Set-ItemProperty -Path $regPath -Name "Destination" -Value $global:Election
        $lblStatus.Text = "📁 Destination: " + $global:Election
    }
})

# Copy Logs
$btnCopy.Add_Click({
    if (-not $global:Election) {
        [System.Windows.Forms.MessageBox]::Show("Please select a destination first.", "Missing Info", "OK", "Warning")
        return
    }

    $todayDate = (Get-Date).ToString("yyyyMMdd")
    $destination = Join-Path -Path $global:Election -ChildPath "$todayDate\$global:machineName"
    if (-not (Test-Path $destination)) {
        New-Item -Path $destination -ItemType Directory -Force | Out-Null
    }

    foreach ($selectedRow in $DataGridView.SelectedRows) {
        $serviceName = $selectedRow.Cells[0].Value
        $fullFolderName = (Get-ChildItem -Path "\\$global:machineName\c$\ProgramData\Dalet\DaletLogs" -Directory | Where-Object { $_.Name -like "*$serviceName*" }).FullName
        if ($fullFolderName) {
            $destFolder = Join-Path -Path $destination -ChildPath $serviceName
            Copy-Item -Path $fullFolderName -Destination $destFolder -Recurse -Force
        }
    }

    Invoke-Item $destination
})

$Form.ShowDialog()
