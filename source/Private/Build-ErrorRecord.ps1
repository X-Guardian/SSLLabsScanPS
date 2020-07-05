function Build-ErrorRecord
{
    <#
    .SYNOPSIS
        Build an error record from an exception object.

    .DESCRIPTION
        This function builds an error record from an exception object.

    .PARAMETER Exception
        Specifies the exception object to include in the error record.

    .INPUTS
        None

    .OUTPUTS
        System.Management.Automation.ErrorRecord

    .EXAMPLE
        Build-ErrorRecord -Exception $exception

        Builds an error record containing the specified exception.
    #>
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory,
            Position = 1)]
        [ValidateNotNullOrEmpty()]
        [System.Exception]
        $Exception
    )

    $exceptionTypeName = $Exception.GetType().FullName

    if ($exceptionTypeName -eq 'System.Net.WebException' -or
        $exceptionTypeName -eq 'Microsoft.PowerShell.Commands.HttpResponseException')
    {
        $fullyQualifiedErrorId = ("$($errorRecord.Exception.Response.StatusCode.value__)-" +
            $errorRecord.Exception.Response.StatusCode)
    }
    else
    {
        $fullyQualifiedErrorId = 'UnknownException'
    }

    $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
        $Exception,
        $fullyQualifiedErrorId,
        [System.Management.Automation.ErrorCategory]::InvalidOperation,
        $Null
    )

    return $ErrorRecord
}
