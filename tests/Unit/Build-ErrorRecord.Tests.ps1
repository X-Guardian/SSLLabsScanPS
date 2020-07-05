<#
.Synopsis
   Tests for Build-ErrorRecord
#>

[CmdletBinding()]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '',
    Justification = 'Suppress false positives in Pester code blocks')]
param()

$ProjectName = 'SSLLabsScanPS'

Import-Module $ProjectName

InModuleScope $ProjectName {
    Describe 'SSLLabsScanPS/Build-ErrorRecord' {
        Context 'When successfully invoked' {
            BeforeAll {
                $mockErrorMessage = 'Error Message'
                $mockException = [System.Exception]::new($mockErrorMessage)
                $result = Build-ErrorRecord -Exception $mockException
            }

            It 'Should return the correct results' {
                $result | Should -BeOfType 'System.Management.Automation.ErrorRecord'
                $result.Exception.Message | Should -Be $mockErrorMessage
            }
        }
    }
}
