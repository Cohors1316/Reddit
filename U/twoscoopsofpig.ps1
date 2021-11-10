Set-StrictMode -Version 3.0
$ErrorActionPreference = 'Stop'
$Error.Clear()

Trap [System.Management.Automation.CommandNotFoundException] {
    Switch ($_.Exception.CommandName) {
        'Test-Workflow' {
            Write-Host -Object 'Workflow trapped'
        } 'Test-Function' {
            Write-Host -Object 'Function trapped'
        } Default {
            Write-Host -Object "$_ Trapped"
        }
    }
    Continue
}

If ($PSVersionTable.PSVersion.Major -GE 7) {
    Function Test-Function {Param($String)$String}
} Else {
    Invoke-Expression -Command @'
        Workflow Test-Workflow {Param($String)$String}
        Workflow Test-Workflow2 {Param($String)$String}
'@
}

Test-Function -String 'This is a function'
Test-Workflow -String 'This is a workflow'
Test-Workflow2 -String 'This is a second workflow'
Write-Host -Object 'Script ended without committing suicide'
