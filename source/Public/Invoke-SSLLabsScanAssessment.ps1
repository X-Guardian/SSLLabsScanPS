function Invoke-SSLLabsScanAssessment
{
    <#
    .SYNOPSIS
        Invokes an SSL Labs scan assessment of a website

    .DESCRIPTION
        This function invokes an SSL Labs scan assessment of a website

    .PARAMETER HostName

    .PARAMETER Publish

    .PARAMETER StartNew

    .PARAMETER FromCache

    .PARAMETER MaxAge

    .PARAMETER All

    .PARAMETER IgnoreMismatch

    .PARAMETER PollingInterval

    .INPUTS
        None

    .OUTPUTS
        SSLLabsScan.Info

    .EXAMPLE
        Invoke-SSLLabsScanAssessment

        Invokes an SSL Labs scan assessment of a website
#>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType( { ($script:ApiPropertes | Where-Object -Property ApiName -eq 'info').TypeName })]
    param(
        [Parameter(Mandatory)]
        [System.String]
        $HostName,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Publish,

        [Parameter(ParameterSetName = 'StartNew')]
        [System.Management.Automation.SwitchParameter]
        $StartNew,

        [Parameter(ParameterSetName = 'FromCache')]
        [System.Management.Automation.SwitchParameter]
        $FromCache,

        [Parameter(ParameterSetName = 'FromCache')]
        [System.Int32]
        $MaxAge,

        [Parameter()]
        [ValidateSet('On', 'Done')]
        [System.String]
        $All,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $IgnoreMismatch,

        [Parameter()]
        [System.Int32]
        $PollingInterval = 10

    )

    $apiName = 'analyze'

    $queryParams = @()

    $queryParams += "host=$HostName"

    if ($PSBoundParameters.ContainsKey('Publish'))
    {
        $queryParams += 'publish=on'
    }

    if ($PSBoundParameters.ContainsKey('FromCache'))
    {
        $queryParams += 'fromCache=on'
    }

    if ($PSBoundParameters.ContainsKey('MaxAge'))
    {
        $queryParams += "maxAge=$MaxAge"
    }

    if ($PSBoundParameters.ContainsKey('All'))
    {
        $queryParams += "all=$All"
    }

    if ($PSBoundParameters.ContainsKey('IgnoreMismatch'))
    {
        $queryParams += 'ignoreMismatch=on'
    }

    $initialQueryParams = $queryParams

    # Only add the 'startNew' parameter on the initial query
    if ($PSBoundParameters.ContainsKey('StartNew'))
    {
        $initialQueryParams += 'startNew=on'
    }

    Write-Verbose "Invoking SSL Labs Scan API Analysis on host $HostName"

    $result = Invoke-SSLLabsScanApi -ApiName $apiName -QueryParameters $initialQueryParams -Verbose:$false

    while ($result.status -ne 'READY' -and $result.status -ne 'ERROR')
    {
        Write-Verbose "Checking SSL Labs Scan API Analysis on host $HostName, last status: $($result.status)"

        Start-Sleep -Seconds $PollingInterval

        $result = Invoke-SSLLabsScanApi -ApiName $apiName -QueryParameters $queryParams -Verbose:$false
    }

    # Convert Unix time fields to PowerShell DateTime objects
    $result.startTime = ([System.DateTimeOffset]::FromUnixTimeMilliSeconds($result.startTime)).UtcDateTime
    $result.testTime = ([System.DateTimeOffset]::FromUnixTimeMilliSeconds($result.testTime)).UtcDateTime

    return $result
}
