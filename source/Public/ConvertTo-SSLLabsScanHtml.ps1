function ConvertTo-SSLLabsScanHtml
{
    <#
    .SYNOPSIS
        Converts an SSL Labs Scan to an HTML report

    .DESCRIPTION
        This function converts an SSL Labs Scan to an HTML report

    .PARAMETER EndPointData
        Specifies the endpoint data to use for the report.

    .PARAMETER Path
        Specifies the output path for the report.

    .INPUTS
        None

    .OUTPUTS
        None

    .EXAMPLE
        ConvertTo-SSLLabsScanHtml

        Converts an SSL Labs Scan to an HTML report
#>
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory)]
        [PSCustomObject[]]
        $EndPointData,

        [Parameter()]
        [System.String]
        $Path
    )

    $hostName = $EndPointData[0].hostName
    $scanDate = $EndPointData[0].details.hostStartTime

    $htmlBody = [System.String]::Empty

    if (-not $PSBoundParameters.ContainsKey('Path'))
    {
        $fileName = "$hostName-SSLLabsScanReport-$($scanDate.ToString('yyyyMMdd-HHmmss')).html"
        $Path = Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath $fileName
    }

    $inlineStyleSheet = @(
        '<style>'
        (Get-Content -Path "$script:resourceDirectoryName\default.css")
        '</style>'
    )

    $header = "SSLLabs Scan for $hostName"

    $preContent = "<h2>$header</h2>"

    foreach ($endpoint in $EndpointData)
    {
        $protocols = @()
        foreach ($protocol in $EndPointData.details.protocols)
        {
            $protocols += "$($protocol.name) v$($protocol.version)"
        }

        $cipherSuites = ($EndPointData.details.suites.list.name | Out-String).Trim() -replace ('\r\n', '<br/>')

        $openSslCcsStatusMapping = @{
            -1 = 'Test Failed'
            0  = 'Unknown'
            1  = 'Not Vulnerable'
            2  = 'Possible Vulnerable, but not Exploitable'
            3  = 'Vulnerable and Exploitable'
        }

        $openSslCcsStatus = $openSslCcsStatusMapping[$EndPointData.details.openSslCcs]

        $openSslLuckyMinus20StatusMapping = @{
            -1 = 'Test Failed'
            0  = 'Unknown'
            1  = 'Not Vulnerable'
            2  = 'Vulnerable and Insecure'
        }

        $openSslLuckyMinus20Status = $openSslLuckyMinus20StatusMapping[$EndPointData.details.openSSLLuckyMinus20]

        $poodleTlsStatusMapping = @{
            -3 = 'Timeout'
            -2 = 'TLS Not Supported'
            -1 = 'Test Failed'
            0  = 'Unknown'
            1  = 'Not Vulnerable'
            2  = 'Vulnerable'
        }

        $poodleTlsStatus = $poodleTlsStatusMapping[$EndPointData.details.poodleTls]

        $reportData = [PSCustomObject][Ordered]@{
            'IP Address'                    = $EndPointData.ipAddress
            'Grade'                         = $EndPointData.grade
            'Grade Ignoring Trust'          = $EndPointData.gradeTrustIgnored
            'Has Warnings'                  = $EndPointData.hasWarnings
            'Is Exceptional'                = $EndPointData.isExceptional
            'Certificate Subject'           = $EndPointData.details.cert.subject
            'Supported Protocols'           = $protocols -join ', '
            'Supported Cipher Suites'       = $cipherSuites
            'BEAST Vulnerable'              = $EndPointData.details.vulnBeast
            'Heartbleed Vulnerable'         = $EndPointData.details.Heartbleed
            'Poodle Vulnerable'             = $EndPointData.details.poodle
            'PoodleTLS Status'              = $poodleTlsStatus
            'FREAK Vulnerable'              = $EndPointData.details.freak
            'Drown Vulnerable'              = $EndPointData.details.drownVulnerable
            'OpenSSL CCS Status'            = $openSslCcsStatus
            'OpenSSL Lucky Minus 20 Status' = $openSslLuckyMinus20Status
        }

        $htmlBody += $reportData | ConvertTo-Html -As List -Fragment

    }

    $htmlReport = ConvertTo-Html -Head $inlineStyleSheet -PreContent $preContent -PostContent $htmlBody

    [System.Net.WebUtility]::HtmlDecode($htmlReport) | Out-File -FilePath $Path -Encoding ascii
}
