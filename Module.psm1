#Requires -Version 3

Function InvokeAsmGet
{
    [CmdletBinding(ConfirmImpact='None')]
    param
    (
        # Uri
        [Parameter(Mandatory=$true)]
        [System.Uri]
        $Uri,
        [Parameter(Mandatory=$true)]
        [String]
        $AuthToken,        
        [Parameter(Mandatory=$true)]
        [String]
        $ApiVersion
    )

    $Headers=@{
        'x-ms-version'=$ApiVersion;
        'Authorization'="Bearer $AuthToken"
    }
    $Result=Invoke-RestMethod -Uri $Uri -Method Get -UseBasicParsing -Headers $Headers
    Write-Output $Result
}

Function InvokeAsmDelete
{
    [CmdletBinding(ConfirmImpact='None')]
    param
    (
        # Uri
        [Parameter(Mandatory=$true)]
        [System.Uri]
        $Uri,
        [Parameter(Mandatory=$true)]
        [String]
        $AuthToken,        
        [Parameter(Mandatory=$true)]
        [String]
        $ApiVersion
    )
}

Function InvokeAsmPut
{
    [CmdletBinding(ConfirmImpact='None')]
    param
    (
        # Uri
        [Parameter(Mandatory=$true)]
        [System.Uri]
        $Uri,
        [Parameter(Mandatory=$true)]
        [String]
        $AuthToken,
        [Parameter(Mandatory=$true)]
        [String]
        $RequestBody,              
        [Parameter(Mandatory=$true)]
        [String]
        $ApiVersion
    )
}

<#
    .SYNOPSIS
        Retrieves the subscriptions
    .PARAMETER SubscriptionId
        The subscription id
    .PARAMETER AuthToken
        The authorization token
    .PARAMETER ApiVersion
        The api version to use
#>
Function Get-ASMSubscription
{
    [CmdletBinding(ConfirmImpact='None')]
    param
    (
        [Parameter(Mandatory=$false)]
        [string]
        $SubscriptionId,
        [Parameter(Mandatory=$true)]
        [String]
        $AuthToken,
        [Parameter(Mandatory=$false)]
        [String]
        $ApiVersion= '2013-08-01'  
    ) 
    $UrlBld=New-Object System.UriBuilder("https://management.core.windows.net")
    if ([String]::IsNullOrEmpty($SubscriptionId)) {
        $UrlBld.Path="subscriptions"
        $Result=InvokeAsmGet -Uri $UrlBld.Uri -AuthToken $AuthToken -ApiVersion $ApiVersion
    }
    else {
        $UrlBld.Path="$SubscriptionId"
        $Result=InvokeAsmGet -Uri $UrlBld.Uri -AuthToken $AuthToken -ApiVersion $ApiVersion
    }
    Write-Output $Result
}

<#
    .SYNOPSIS
        Retrieves the cloud services within the subscription
    .PARAMETER SubscriptionId
        The subscription id
    .PARAMETER AuthToken
        The authorization token
    .PARAMETER Name
        The cloud service name
    .PARAMETER ApiVersion
        The api version to use
#>
Function Get-ASMCloudService
{
    [CmdletBinding(ConfirmImpact='None')]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $SubscriptionId,
        [Parameter(Mandatory=$true)]
        [String]
        $AuthToken,        
        [Parameter(Mandatory=$false)]
        [string]
        $Name,
        [Parameter(Mandatory=$false)]
        [String]
        $ApiVersion= '2013-08-01'  
    )

    $UrlBld=New-Object System.UriBuilder("https://management.core.windows.net")
    if ([String]::IsNullOrEmpty($Name)) {
        $UrlBld.Path="$SubscriptionId/services/hostedservices"
    }
    else {
        $UrlBld.Path="$SubscriptionId/services/hostedservices/$Name"
    }
    $Result=InvokeAsmGet -Uri $UrlBld.Uri -AuthToken $AuthToken -ApiVersion $ApiVersion
    Write-Output $Result

}

<#
    .SYNOPSIS
        Retrieves the virtual networks within the subscription
    .PARAMETER SubscriptionId
        The subscription id
    .PARAMETER AuthToken
        The authorization token
    .PARAMETER Name
        The virtual network name
    .PARAMETER ApiVersion
        The api version to use
#>
Function Get-ASMVirtualNetwork
{
    [CmdletBinding(ConfirmImpact='None')]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $SubscriptionId,
        [Parameter(Mandatory=$true)]
        [String]
        $AuthToken,        
        [Parameter(Mandatory=$false)]
        [string]
        $Name,
        [Parameter(Mandatory=$false)]
        [String]
        $ApiVersion= '2012-03-01'
    )

    $UrlBld=New-Object System.UriBuilder("https://management.core.windows.net")
    if ([String]::IsNullOrEmpty($Name)) {
        $UrlBld.Path="$SubscriptionId/services/networking/virtualnetwork"
    }
    else {
        $UrlBld.Path="$SubscriptionId/services/networking/virtualnetwork/$Name"
    }
    $Result=InvokeAsmGet -Uri $UrlBld.Uri -AuthToken $AuthToken -ApiVersion $ApiVersion
    Write-Output $Result
}

<#
    .SYNOPSIS
        Retrieves the sql servers within the subscription
    .PARAMETER SubscriptionId
        The subscription id
    .PARAMETER AuthToken
        The authorization token
    .PARAMETER Name
        The sql server name
    .PARAMETER ApiVersion
        The api version to use
#>
Function Get-ASMSqlServer
{
    [CmdletBinding(ConfirmImpact='None')]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $SubscriptionId,
        [Parameter(Mandatory=$true)]
        [String]
        $AuthToken,        
        [Parameter(Mandatory=$false)]
        [string]
        $Name,
        [Parameter(Mandatory=$false)]
        [String]
        $ApiVersion= '2012-03-01',
        [Parameter(Mandatory=$false)]
        [Switch]
        $MakeGeneric
    )
    $UrlBld=New-Object System.UriBuilder("https://management.core.windows.net")
    if ([String]::IsNullOrEmpty($Name)) {
        $UrlBld.Path="$SubscriptionId/services/sqlservers/servers"
    }
    else {
        $UrlBld.Path="$SubscriptionId/services/sqlservers/servers/$Name"
    }
    if ($MakeGeneric.IsPresent) {
        $UriBld.Query="contentview=generic"
    }
    $Result=InvokeAsmGet -Uri $UrlBld.Uri -AuthToken $AuthToken -ApiVersion $ApiVersion
    Write-Output $Result    
}

<#
    .SYNOPSIS
        Retrieves the sql servers within the subscription
    .PARAMETER SubscriptionId
        The subscription id
    .PARAMETER AuthToken
        The authorization token
    .PARAMETER Name
        The sql server name
    .PARAMETER ApiVersion
        The api version to use
#>
Function Get-ASMSqlDatabase
{
    [CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='explicit')]
    param
    (
        [Parameter(Mandatory=$true,ParameterSetName='explicit')]
        [string]
        $SubscriptionId,
        [Parameter(Mandatory=$true,ParameterSetName='server')]
        [Parameter(Mandatory=$true,ParameterSetName='explicit')]
        [String]
        $AuthToken,        
        [Parameter(Mandatory=$true,ParameterSetName='explicit')]
        [string]
        $ServerName,
        [Parameter(Mandatory=$true,ParameterSetName='server')]
        [psobject]
        $Server,        
        [Parameter(Mandatory=$false,ParameterSetName='explicit')]
        [string]
        $Name,
        [Parameter(Mandatory=$false,ParameterSetName='server')]
        [Parameter(Mandatory=$false,ParameterSetName='explicit')]
        [String]
        $ApiVersion= '2012-03-01',
        [Parameter(Mandatory=$false,ParameterSetName='server')]
        [Parameter(Mandatory=$false,ParameterSetName='explicit')]
        [Switch]
        $MakeGeneric
    )
    if($PSCmdlet.ParameterSetName -eq 'explicit')
    {
        $UrlBld=New-Object System.UriBuilder("https://management.core.windows.net")
        $UrlBld.Path="$SubscriptionId/services/sqlservers/servers/$ServerName/databases"
    }
    else {
        
        if ([String]::IsNullOrEmpty($Server.ServiceResource.SelfLink) -eq $false) {
            $BaseUri=$Server.ServiceResource.SelfLink
        }
        elseif ([String]::IsNullOrEmpty($Server.SelfLink) -eq $false) {
            $BaseUri=$Server.SelfLink
        }
        else {
            throw "Unable to find a ''ServiceResource.SelfLink' or 'SelfLink' property"
        }
        Write-Verbose "Existing DB Server $($BaseUri)"
        $UrlBld=New-Object System.UriBuilder($BaseUri)
        $UriBld.Path="$($UrlBld.Path)/databases"
    }
    if ([String]::IsNullOrEmpty($Name)) {
        $UrlBld.Path="$($UrlBld.Path)/$Name"
    }
    if ($MakeGeneric.IsPresent) {
        $UriBld.Query="contentview=generic"
    }
    $Result=InvokeAsmGet -Uri $UrlBld.Uri -AuthToken $AuthToken -ApiVersion $ApiVersion
    Write-Output $Result    
}

<#
    .SYNOPSIS
        Retrieves the sql server firewall rules within the subscription
    .PARAMETER SubscriptionId
        The subscription id
    .PARAMETER AuthToken
        The authorization token
    .PARAMETER Name
        The firewall rule name
    .PARAMETER ApiVersion
        The api version to use
#>
Function Get-ASMSqlServerFirewallRule
{
    [CmdletBinding(ConfirmImpact='None',DefaultParameterSetName='explicit')]
    param
    (
        [Parameter(Mandatory=$true,ParameterSetName='explicit')]
        [string]
        $SubscriptionId,
        [Parameter(Mandatory=$true,ParameterSetName='server')]
        [Parameter(Mandatory=$true,ParameterSetName='explicit')]
        [String]
        $AuthToken,        
        [Parameter(Mandatory=$true,ParameterSetName='explicit')]
        [string]
        $ServerName,
        [Parameter(Mandatory=$true,ParameterSetName='server')]
        [psobject]
        $Server,        
        [Parameter(Mandatory=$false,ParameterSetName='explicit')]
        [string]
        $Name,
        [Parameter(Mandatory=$false,ParameterSetName='server')]
        [Parameter(Mandatory=$false,ParameterSetName='explicit')]
        [String]
        $ApiVersion= '2012-03-01'
    )
    if($PSCmdlet.ParameterSetName -eq 'explicit')
    {
        $UrlBld=New-Object System.UriBuilder("https://management.core.windows.net")
        $UrlBld.Path="$SubscriptionId/services/sqlservers/servers/$ServerName/firewallrules"
    }
    else {
        
        if ([String]::IsNullOrEmpty($Server.ServiceResource.SelfLink) -eq $false) {
            $BaseUri=$Server.ServiceResource.SelfLink
        }
        elseif ([String]::IsNullOrEmpty($Server.SelfLink) -eq $false) {
            $BaseUri=$Server.SelfLink
        }
        else {
            throw "Unable to find a ''ServiceResource.SelfLink' or 'SelfLink' property"
        }
        Write-Verbose "Existing DB Server $($BaseUri)"
        $UrlBld=New-Object System.UriBuilder($BaseUri)
        $UriBld.Path="$($UrlBld.Path)/databases"
    }
    if ([String]::IsNullOrEmpty($Name)) {
        $UrlBld.Path="$($UrlBld.Path)/$Name"
    }
    $Result=InvokeAsmGet -Uri $UrlBld.Uri -AuthToken $AuthToken -ApiVersion $ApiVersion
    Write-Output $Result    
}

<#
    .SYNOPSIS
        Returns the list of Os Images associated with the subscription
    .PARAMETER SubscriptionId
        The subscription id
    .PARAMETER AuthToken
        The authorization token
    .PARAMETER ApiVersion
        The api version used  
#>
Function Get-ASMOsImages
{
    [CmdletBinding(ConfirmImpact='None')]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $SubscriptionId,
        [Parameter(Mandatory=$true)]
        [String]
        $AuthToken,
        [Parameter(Mandatory=$false)]
        [String]
        $ApiVersion= '2013-03-01'
    )
    $UrlBld=New-Object System.UriBuilder("https://management.core.windows.net")
    $UrlBld.Path="subscriptions/$SubscriptionId/services/images"
    $Result=InvokeAsmGet -Uri $UrlBld.Uri -AuthToken $AuthToken -ApiVersion $ApiVersion
    Write-Output $Result
}

<#
    .SYNOPSIS
        Returns the list of VM Images associated with the subscription
    .PARAMETER SubscriptionId
        The subscription id
    .PARAMETER AuthToken
        The authorization token
    .PARAMETER ApiVersion
        The api version used        
#>
Function Get-ASMVmImages
{
    [CmdletBinding(ConfirmImpact='None')]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $SubscriptionId,
        [Parameter(Mandatory=$true)]
        [String]
        $AuthToken,
        [Parameter(Mandatory=$false)]
        [String]
        $ApiVersion= '2014-05-01',
        [Parameter(Mandatory=$false)]
        [String]
        $Location,
        [Parameter(Mandatory=$false)]
        [String]
        $Publisher,
        [Parameter(Mandatory=$false)]
        [String]
        $Category                      
    )
    $UrlBld=New-Object System.UriBuilder("https://management.core.windows.net")
    $UrlBld.Path="subscriptions/$SubscriptionId/services/vmimages"
    $QueryParams=@()
    if ([string]::IsNullOrEmpty($Location) -ne $false) {
        $QueryParams+="location=$Location"
    }
    if ([string]::IsNullOrEmpty($Publisher) -ne $false) {
        $QueryParams+="publisher=$Publisher"
    }
    if ([string]::IsNullOrEmpty($Category) -ne $false) {
        $QueryParams+="category=$Category"
    }
    $UrlBld.Query=[String]::Join('&',$QueryParams)
    $Result=InvokeAsmGet -Uri $UrlBld.Uri -AuthToken $AuthToken -ApiVersion $ApiVersion
    Write-Output $Result
}

<#
    .SYNOPSIS
        Retrieves the deployments associated with a cloud service
    .PARAMETER SubscriptionId
        The subscription id
    .PARAMETER CloudServiceName
        The cloud service name
    .PARAMETER Name
        The deployment name
    .PARAMETER Staging
        Whether to query the staging slot
    .PARAMETER AuthToken
        The authorization token
    .PARAMETER ApiVersion
        The api version used
#>
Function Get-ASMCloudServiceDeployment
{
    [CmdletBinding(ConfirmImpact='None')]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $SubscriptionId,
        [Parameter(Mandatory=$true)]
        [String]
        $AuthToken,        
        [Parameter(Mandatory=$true)]
        [string]
        $CloudServiceName,
        [Parameter(Mandatory=$false)]
        [string]
        $Name,
        [Parameter(Mandatory=$false)]
        [String]
        $ApiVersion= '2012-03-01',
        [Parameter(Mandatory=$false)]
        [Switch]
        $Staging
    )
    $UrlBld=New-Object System.UriBuilder("https://management.core.windows.net")
    if([String]::IsNullOrEmpty($Name))
    {
        $DeploymentSlot='Production'
        if($Staging.IsPresent)
        {
            $DeploymentSlot='Staging'
        }
        $UrlBld.Path="$SubscriptionId/services/hostedservices/$CloudServiceName/deploymentslots/$DeploymentSlot"    
    }
    else
    {
        $UrlBld.Path="$SubscriptionId/services/hostedservices/$CloudServiceName/deployments/$Name" 
    }
    $Result=InvokeAsmGet -Uri $UrlBld.Uri -AuthToken $AuthToken -ApiVersion $ApiVersion
    Write-Output $Result
}

<#
    .SYNOPSIS
        Retrieves the roles associated with a cloud service
    .PARAMETER SubscriptionId
        The subscription id
    .PARAMETER CloudServiceName
        The cloud service name
    .PARAMETER DeploymentName
        The deployment name
    .PARAMETER DeploymentName
        The role name
    .PARAMETER AuthToken
        The authorization token
    .PARAMETER ApiVersion
        The api version used
#>
Function Get-ASMCloudServiceRole
{
    [CmdletBinding(ConfirmImpact='None')]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $SubscriptionId,
        [Parameter(Mandatory=$true)]
        [String]
        $AuthToken,        
        [Parameter(Mandatory=$true)]
        [string]
        $CloudServiceName,
        [Parameter(Mandatory=$true)]
        [string]
        $DeploymentName,
        [Parameter(Mandatory=$true)]
        [string]
        $Name,
        [Parameter(Mandatory=$false)]
        [String]
        $ApiVersion= '2012-03-01'
    )
    $UrlBld=New-Object System.UriBuilder("https://management.core.windows.net")
    $UrlBld.Path="$SubscriptionId/services/hostedservices/$CloudServiceName/deployments/$DeploymentName/roles/$Name"
    $Result=InvokeAsmGet -Uri $UrlBld.Uri -AuthToken $AuthToken -ApiVersion $ApiVersion
    Write-Output $Result
}

Function Get-ASMCloudServiceDeploymentEvent
{
    [CmdletBinding(ConfirmImpact='None')]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $SubscriptionId,
        [Parameter(Mandatory=$true)]
        [String]
        $AuthToken,        
        [Parameter(Mandatory=$true)]
        [string]
        $CloudServiceName,
        [Parameter(Mandatory=$false)]
        [string]
        $Name,
        [Parameter(Mandatory=$false)]
        [String]
        $ApiVersion= '2014-06-01',
        [Parameter(Mandatory=$false)]
        [System.DateTime]
        $StartTime,
        [Parameter(Mandatory=$false)]
        [System.DateTime]
        $EndTime,
        [Parameter(Mandatory=$false)]
        [Switch]
        $Staging
    )
    $UrlBld=New-Object System.UriBuilder("https://management.core.windows.net")
    if($EndTime -eq $null)
    {
        $EndTime=[DateTime]::UtcNow
    }
    if($StartTime -eq $null)
    {
        $StartTime=$EndTime.AddDays(-1)
    }
    if([String]::IsNullOrEmpty($Name))
    {
        $DeploymentSlot='Production'
        if($Staging.IsPresent)
        {
            $DeploymentSlot='Staging'
        }
        $UrlBld.Path="$SubscriptionId/services/hostedservices/$CloudServiceName/deploymentslots/$DeploymentSlot/events"    
    }
    else
    {
        $UrlBld.Path="$SubscriptionId/services/hostedservices/$CloudServiceName/deployments/$Name/events" 
    }
    $UrlBld.Query="StartTime=$($StartTime.ToString('o'))&EndTime=$($EndTime.ToString('o'))"
    $Result=InvokeAsmGet -Uri $UrlBld.Uri -AuthToken $AuthToken -ApiVersion $ApiVersion
    Write-Output $Result
}

Function Get-ASMCloudServiceRoleIpForwarding
{
    [CmdletBinding(ConfirmImpact='None')]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $SubscriptionId,
        [Parameter(Mandatory=$true)]
        [String]
        $AuthToken,        
        [Parameter(Mandatory=$true)]
        [string]
        $CloudServiceName,
        [Parameter(Mandatory=$true)]
        [string]
        $DeploymentName,
        [Parameter(Mandatory=$true)]
        [string]
        $Name,
        [Parameter(Mandatory=$false)]
        [String]
        $ApiVersion= '2012-03-01',
        [Parameter(Mandatory=$false)]
        [Switch]
        $Staging
    )
    $UrlBld=New-Object System.UriBuilder("https://management.core.windows.net")
    $UrlBld.Path="$SubscriptionId/services/hostedservices/$CloudServiceName/deployments/$DeploymentName/roles/$Name/ipforwarding"
    $Result=InvokeAsmGet -Uri $UrlBld.Uri -AuthToken $AuthToken -ApiVersion $ApiVersion
    Write-Output $Result
}