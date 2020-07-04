# SSLLabsScanPS

[![Build Status](https://dev.azure.com/simonheather99/SSLLabsScanPS/_apis/build/status/simonheather99.SSLLabsScanPS?branchName=master)](https://dev.azure.com/simonheather99/SSLLabsScanPS/_build/latest?definitionId=4&branchName=master)
![Azure DevOps coverage (branch)](https://img.shields.io/azure-devops/coverage/simonheather99/SSLLabsScanPS/4/master)
[![Azure DevOps tests](https://img.shields.io/azure-devops/tests/simonheather99/SSLLabsScanPS/4/master)](https://simonheather99.visualstudio.com/SSLLabsScanPS/_test/analytics?definitionId=4&contextType=build)
[![PowerShell Gallery (with prereleases)](https://img.shields.io/powershellgallery/vpre/SSLLabsScanPS?label=SSLLabsScanPS%20Preview)](https://www.powershellgallery.com/packages/SSLLabsScanPS/)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/SSLLabsScanPS?label=SSLLabsScanPS)](https://www.powershellgallery.com/packages/SSLLabsScanPS/)

PowerShell Wrapper for the [SSL Labs Assessment API](https://github.com/ssllabs/ssllabs-scan/blob/stable/ssllabs-api-docs.md)

## Releases

For each merge to the branch `master` a preview release will be
deployed to [PowerShell Gallery](https://www.powershellgallery.com/).
Periodically a release version tag will be pushed which will deploy a
full release to [PowerShell Gallery](https://www.powershellgallery.com/).

## Installation

You can get latest release of the SSLLabsScanPS module on the [PowerShell Gallery](https://www.powershellgallery.com/packages/SSLLabsScanPS)

```PowerShell
Install-Module -Name SSLLabsScanPS
```

## Usage

### Invoke a new assessment of a website and produce a summary HTML report

```PowerShell
$hostData = Invoke-SSLLabsScanAssessment -HostName www.mwam.com -StartNew -All Done
ConvertTo-SSLLabsScanHtml -EndpointData $hostData.endpoints
```

### Retrive a cached assessment of a website and produce a summary HTML report

```PowerShell
$hostData = Invoke-SSLLabsScanAssessment -HostName www.mwam.com -FromCache -All Done
ConvertTo-SSLLabsScanHtml -EndpointData $hostData.endpoints
```

### Retrive a cached assessment of a particular host of a website and produce a summary HTML report

```PowerShell
$EndPointData = Get-SSLLabsScanEndpointData -HostName www.mwam.com -IPAddress '18.132.32.101' -FromCache
ConvertTo-SSLLabsScanHtml -EndpointData $hostData.endpoints
```

## Change log

A full list of changes in each version can be found in the [change log](CHANGELOG.md).

## Licensing

SSLLabsScanPS is licensed under the [MIT license](LICENSE).
