Function Invoke-SSLLabsScanApi
{
    <#
    .SYNOPSIS
        Invoke the SSLLabs Scan API

    .DESCRIPTION
        This function invokes the SSLLabs Scan API

    .PARAMETER ApiName
        Specifies the name of the API to invoke

    .PARAMETER QueryParameters
        Specifies the query parameters for the API

    .INPUTS
        None

    .OUTPUTS
        System.Management.Automation.PSCustomObject

    .EXAMPLE
        Invoke-SSLLabsScanApi -ApiName 'info'

        Invokes the SSLLabs Scan Info API.
#>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param(
        [Parameter(
            Mandatory,
            Position = 1)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ApiName,

        [Parameter()]
        [System.String[]]
        $QueryParameters
    )

    $endpoint = $script:baseEndpoint + $ApiName

    if ($QueryParameters)
    {
        $queryString = '?' + ($QueryParameters -join '&')
        $Uri = $endpoint + $queryString
    }
    else
    {
        $uri = $endpoint
    }

    Write-Debug -Message "Invoking RestMethod with URI $Uri"

    # Disable Write-Progress for Invoke-RestMethod to improve performance
    $ProgressPreference = 'SilentlyContinue'

    try
    {
        $result = Invoke-RestMethod -Uri $Uri
    }
    catch
    {
        throw $_
    }

    $typeName = ($script:apiProperties | Where-Object -Property 'ApiName' -eq $ApiName).TypeName
    $result.PSTypeNames.Insert(0, $typeName)

    return $result
}
