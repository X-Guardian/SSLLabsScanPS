function Get-SSLLabsScanEndpointData
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

    .PARAMETER
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

        [Parameter(Mandatory)]
        [System.String[]]
        $IPAddress,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $FromCache
    )

    $apiName = 'getEndpointData'

    $baseQueryParams = @()

    $baseQueryParams += "host=$HostName"

    if ($PSBoundParameters.ContainsKey('FromCache'))
    {
        $baseQueryParams += 'fromCache=on'
    }

    foreach ($ip in $IPAddress)
    {
        $queryParams = $baseQueryParams + "s=$ip"
        Write-Verbose "Getting SSL Labs Scan endpoint data on host $HostName, IP address $ip"

        $result = Invoke-SSLLabsScanApi -ApiName $apiName -QueryParameters $queryParams -Verbose:$false

        $result | Add-Member -Name 'hostName' -Value $HostName -MemberType NoteProperty
        $result.details.hostStartTime = ([System.DateTimeOffset]::FromUnixTimeMilliSeconds($result.details.hostStartTime)).UtcDateTime

        return $result
    }
}
