function Get-SSLLabsScanEndpointData
{
    <#
    .SYNOPSIS
        Gets the endpoint data for a scan

    .DESCRIPTION
        This function gets the endpoint data for a scan

    .PARAMETER HostName
        Specifies the hostname of the scan.

    .PARAMETER IPAddress
        Specifies the ip address of the host in the scan.

    .PARAMETER FromCache
        Specifies whether to retrieve the scan from the cache.

    .INPUTS
        None

    .OUTPUTS
        SSLLabsScan.EndPointData

    .EXAMPLE
        Get-SSLLabsScanEndpointData -HostName www.bbc.co.uk -IPAddress 1.1.1.1

        Gets the endpoint data for a scan
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
