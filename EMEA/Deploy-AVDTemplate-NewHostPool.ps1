<#
==============================================================================

*********** AVD Implementation for Cantor ************

File:      Deploy-AVDTemplate-NewHostPool.ps1
Author:    

Purpose:   Deploys additional HostPools, AppGroups and Session Hosts
                      
This script is provided "AS IS" with no warranties, confers no rights and 
is not supported by the authors. 

==============================================================================
#>


#==============================================================================
# Variable Declaration
#==============================================================================

# Set Subscription to bgc-emea-infrastructure-prod
$subscriptionId = "4fe83d79-cc9d-484f-bf8a-803ec70bac45"
Select-AzSubscription -SubscriptionId $subscriptionId

# Set ARM Template Root Path. This is the location you have cloned the repo too.
# Set-Location "Z:\Azure Devops\b\CFAVDSept2021\WVD\ARM Templates"
Set-Location "C:\Azure Devops\b\CFAVDFeb2022\AVD\EMEA"

# Set Azure Resource Location
# Get-AzLocation | sort-object location | ft Location, Displayname
# = "East US 2"
$Location = "uksouth"

# Set HostPool resourcegroup name where avd vm objects will be deployed to.
#us $ITresourceGroup = "eus2-rg-wvd-ews-hp"
$AVDresourceGroup = "uks-rg-avd-bo-hp1"

# Set the azuredeploy template parameters file nme identifier. Change he to change Hostpool, Apps, and SessionHost parameter file name thats referenced.
$grp = "bo"
# $ENV only used when create a new workspace.
#$env = "prd"

# Set Cantor TAGS
$Tags = @{`
        ApplicationName   = ""; `
        ApplicationOwner  = ""; `
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
# Create WVD HostPools
#==============================================================================

# New AVD HostPool resourcegroup
New-AzResourceGroup `
    -Name $AVDresourceGroup `
    -Location $location `
    -Tag $Tags

# New-IT Production HostPool
New-AzResourceGroupDeployment `
    -ResourceGroupName $AVDresourceGroup `
    -TemplateFile .\HostPools\azuredeploy.json `
    -TemplateParameterFile .\HostPools\azuredeploy.parameters."$grp"-hp1.json `
    -Verbose `
    -Force

#==============================================================================
# Create WVD AppGroups
#==============================================================================

# New-IT Production App Group 
New-AzResourceGroupDeployment `
    -ResourceGroupName $AVDresourceGroup `
    -TemplateFile .\ApplicationGroups\azuredeploy.json `
    -TemplateParameterFile .\ApplicationGroups\azuredeploy.parameters."$grp"-apps1.json `
    -Verbose `
    -Force

#==============================================================================
# Create WVD SessionHosts
#==============================================================================

# New-IT Production Session Hosts 
New-AzResourceGroupDeployment `
    -ResourceGroupName $AVDresourceGroup `
    -TemplateFile .\SessionHosts\azuredeploy.json `
    -TemplateParameterFile .\SessionHosts\azuredeploy.parameters."$grp"-sh1.json `
    -Verbose `
    -Force
