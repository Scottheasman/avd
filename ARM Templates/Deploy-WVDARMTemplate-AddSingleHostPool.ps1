<#
==============================================================================

*********** WVD Implementation for Cantor ************

File:      Deploy-WVDARMTemplate-SingleHostPool.ps1
Author:    

Purpose:   Deploys additional HostPools, AppGroups and Session Hosts
           Some sections are commented out to prohibit deployement. If
           it is necessary to deploy these resources, simply remove the "#". 
                      
This script is provided "AS IS" with no warranties, confers no rights and 
is not supported by the authors. 

==============================================================================
#>


#==============================================================================
# Variable Declaration
#==============================================================================

# Set Subscription
#amer $subscriptionId = "a7b50fa6-5f5f-49b4-aa1c-128242d19284"
$subscriptionId = "4fe83d79-cc9d-484f-bf8a-803ec70bac45"
Select-AzSubscription -SubscriptionId $subscriptionId

# Set ARM Template Root Path
Set-Location "Z:\Azure Devops\b\CFAVDSept2021\WVD\ARM Templates"

# Set Azure Resource Location
#US $Location = "East US 2"
$Location = "uksouth"

# Set WVD Infrastructure RG
$WVDInfraRG = "eus2-rg-wvd-services"

# Set General HostPool RG
#us $ITresourceGroup = "eus2-rg-wvd-ews-hp"
$ITresourceGroup = "uks-rg-avd-dec2-hp"

# Set the New 3 Letter Resource Designation Group and Resource Environment
# Should match the 3 letters you renamed your params file with (i.e. GEN, STD, ITA, etc))
$grp = "dec2"
$env = "prd"

# Set Cantor TAGS
$Tags = @{`
    ApplicationName   = ""; `
ApplicationOwner      = ""; `
    CostCode          = ""; `
    DataProfile       = ""; `
    Department        = ""; `
    Description       = ""; `
    Entity            = ""; `
    Environment       = ""; `
    GLCode            = ""; `
    ProjectName       = ""; `
    ServiceReviewDate = ""; `
    AppID             = ""
}

#==============================================================================
# Create WVD Infrastructure RG
#==============================================================================

<# Create WVD Infrastructure RG (not normally needed)
New-AzResourceGroup `
    -Name $ITresourceGroup `
    -Location $location `
    -Tag $Tags
#>

#==============================================================================
# Create WVD Workspaces
#==============================================================================

<# New-Workspace (not normally needed)
New-AzResourceGroupDeployment `
    -ResourceGroupName $WVDInfraRG `
    -TemplateFile .\Workspaces\azuredeploy.json `
    -TemplateParameterFile .\Workspaces\azuredeploy.parameters.Cantor-Workspace-"$env"".json `
    -Verbose `
    -Force
#>

#==============================================================================
# Create WVD HostPools
#==============================================================================

# WVD IT Production HostPool RG
New-AzResourceGroup `
    -Name $ITresourceGroup `
    -Location $location `
    -Tag $Tags

# New-IT Production HostPool
New-AzResourceGroupDeployment `
    -ResourceGroupName $ITresourceGroup `
    -TemplateFile .\HostPools\azuredeploy.json `
    -TemplateParameterFile .\HostPools\azuredeploy.parameters.Cantor-"$grp"-hp.json `
    -Verbose `
    -Force

#==============================================================================
# Create WVD AppGroups
#==============================================================================

# New-IT Production App Group 
New-AzResourceGroupDeployment `
    -ResourceGroupName $ITresourceGroup `
    -TemplateFile .\ApplicationGroups\azuredeploy.json `
    -TemplateParameterFile .\ApplicationGroups\azuredeploy.parameters.Cantor-"$grp"-apps.json `
    -Verbose `
    -Force

#==============================================================================
# Create WVD SessionHosts
#==============================================================================

# New-IT Production Session Hosts 
New-AzResourceGroupDeployment `
    -ResourceGroupName $ITresourceGroup `
    -TemplateFile .\SessionHosts\azuredeploy.json `
    -TemplateParameterFile .\SessionHosts\azuredeploy.parameters.Cantor-"$grp"-sh.json `
    -Verbose `
    -Force
