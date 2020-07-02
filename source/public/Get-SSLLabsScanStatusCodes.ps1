function Get-SSLLabsScanStatusCodes
{
    <#
    .SYNOPSIS
        Gets details of the SSLLabs Scan API status codes

    .DESCRIPTION
        This function gets details of the SSLLabs Scan API status codes

    .INPUTS
        None

    .OUTPUTS
        SSLLabsScan.StatusCodes

    .EXAMPLE
        Get-SSLLabsScanStatusCodes

        Gets the SSLLabs Scan API info status codes.
#>
    [CmdletBinding()]
    [OutputType({($script:ApiPropertes | Where-Object -Property ApiName -eq 'StatusCodes').TypeName})]
    param()

    $apiName = 'getStatusCodes'

    Write-Verbose 'Getting SSL Labs Scan API Info status codes'

    $result = Invoke-SSLLabsScanApi -ApiName $apiName

    $result.statusDetails
}
