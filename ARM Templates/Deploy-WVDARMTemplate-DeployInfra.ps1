
<#
==============================================================================

*********** WVD Implementation for Cantor ************

File:      Deploy-WVDARMTemplates.ps1
Author:    

Purpose:   Deploys the required WVD infrastructure. In order to deploy
           single resources, either select the area and hit F8, 
           copy the necessary sections into a new PS script or use 
           the Deploy-WVDARMTemplate-SingleHostPool.ps1.           

This script is provided "AS IS" with no warranties, confers no rights and 
is not supported by the authors. 

==============================================================================
#>

#==============================================================================
# Variable Declaration
#==============================================================================

# Set Subscription
$subscriptionId = "a7b50fa6-5f5f-49b4-aa1c-128242d19284"
Select-AzSubscription -SubscriptionId $subscriptionId

# Set ARM Template Root Path
Set-Location "C:\Temp\ARMTemplates_WVD_Infrastructure"

# Set Azure Resource Location
$Location = "East US 2"

# Set WVD Infrastructure RG
$WVDInfraRG = "eus2-rg-wvd-workspace"

# Set All HostPool Resource Groups
$BOresourceGroup = "eus2-rg-wvd-bo-hp"
$FOresourceGroup = "eus2-rg-wvd-fo-hp"
$ITresourceGroup = "eus2-rg-wvd-it-hp"
$DEVSresourceGroup = "eus2-rg-wvd-devs-hp"
$VALresourceGroup = "eus2-rg-wvd-val-hp"
$VIPresourceGroup = "eus2-rg-wvd-vip-hp"
$RAPresourceGroup = "eus2-rg-wvd-rap-hp"

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
# Create WVD Infrastructure Resource Group
#==============================================================================

# Create WVD Infrastructure RG
New-AzResourceGroup -Name $WVDInfraRG -Location $location

#==============================================================================
# Create WVD Resource Groups for Each HostPool
#==============================================================================

# WVD Validation HostPool RG
New-AzResourceGroup `
    -Name $VALresourceGroup `
    -Location $location `
    -Tag $Tags

# WVD Back Office Production HostPool RG
New-AzResourceGroup `
    -Name $BOresourceGroup `
    -Location $location `
    -Tag $Tags

# WVD Front Office Production HostPool RG
New-AzResourceGroup `
    -Name $FOresourceGroup `
    -Location $location `
    -Tag $Tags

# WVD Infrastructure Production HostPool RG
New-AzResourceGroup `
    -Name $ITresourceGroup `
    -Location $location `
    -Tag $Tags

# WVD Developers Production HostPool RG
New-AzResourceGroup `
    -Name $DevsresourceGroup `
    -Location $location `
    -Tag $Tags

# WVD VIP Production HostPool RG
New-AzResourceGroup `
    -Name $VIPsresourceGroup `
    -Location $location `
    -Tag $Tags    

# WVD Remote App HostPool RG
New-AzResourceGroup `
    -Name $RAPresourceGroup `
    -Location $location `
    -Tag $Tags   

#==============================================================================
# Create WVD Workspaces
#==============================================================================

# New-ValidationWorkspace
New-AzResourceGroupDeployment `
    -ResourceGroupName $WVDInfraRG `
    -TemplateFile .\Workspaces\azuredeploy.json `
    -TemplateParameterFile .\Workspaces\azuredeploy.parameters.Cantor-Workspace-val.json `
    -Verbose -Force

# New-ProdWorkspace
New-AzResourceGroupDeployment `
    -ResourceGroupName $WVDInfraRG `
    -TemplateFile .\Workspaces\azuredeploy.json `
    -TemplateParameterFile .\Workspaces\azuredeploy.parameters.Cantor-Workspace-prd.json `
    -Verbose -Force

#==============================================================================
# Create WVD HostPools
#==============================================================================

# New-ValDevHostPool
New-AzResourceGroupDeployment `
    -ResourceGroupName $VALresourceGroup `
    -TemplateFile .\HostPools\azuredeploy.json `
    -TemplateParameterFile .\HostPools\azuredeploy.parameters.Cantor-val-hp.json `
    -Verbose -Force

# New-GenProdHostPool
New-AzResourceGroupDeployment `
    -ResourceGroupName $BOresourceGroup `
    -TemplateFile .\HostPools\azuredeploy.json `
    -TemplateParameterFile .\HostPools\azuredeploy.parameters.Cantor-bo-hp.json `
    -Verbose -Force

# New-StdProdHostPool
New-AzResourceGroupDeployment `
    -ResourceGroupName $FOresourceGroup `
    -TemplateFile .\HostPools\azuredeploy.json `
    -TemplateParameterFile .\HostPools\azuredeploy.parameters.Cantor-fo-hp.json `
    -Verbose -Force

# New-NFormProdHostPool
New-AzResourceGroupDeployment `
    -ResourceGroupName $ITresourceGroup `
    -TemplateFile .\HostPools\azuredeploy.json `
    -TemplateParameterFile .\HostPools\azuredeploy.parameters.Cantor-it-hp.json `
    -Verbose -Force

# New-ProProdHostPool
New-AzResourceGroupDeployment `
    -ResourceGroupName $DEVSresourceGroup `
    -TemplateFile .\HostPools\azuredeploy.json `
    -TemplateParameterFile .\HostPools\azuredeploy.parameters.Cantor-devs-hp.json `
    -Verbose -Force

# New-VIPHostPool
New-AzResourceGroupDeployment `
    -ResourceGroupName $VIPresourceGroup `
    -TemplateFile .\HostPools\azuredeploy.json `
    -TemplateParameterFile .\HostPools\azuredeploy.parameters.Cantor-vip-hp.json `
    -Verbose -Force   

# New-RemoteAppHostPool
New-AzResourceGroupDeployment `
    -ResourceGroupName $RAPresourceGroup `
    -TemplateFile .\HostPools\azuredeploy.json `
    -TemplateParameterFile .\HostPools\azuredeploy.parameters.Cantor-rap-hp.json `
    -Verbose -Force   
#==============================================================================
# Create WVD AppGroups
#==============================================================================

# New-ValAppGroup 
New-AzResourceGroupDeployment `
    -ResourceGroupName $VALresourceGroup `
    -TemplateFile .\ApplicationGroups\azuredeploy.json `
    -TemplateParameterFile .\ApplicationGroups\azuredeploy.parameters.Cantor-val-apps.json `
    -Verbose -Force

# New-BOAppGroup 
New-AzResourceGroupDeployment `
    -ResourceGroupName $BOresourceGroup `
    -TemplateFile .\ApplicationGroups\azuredeploy.json `
    -TemplateParameterFile .\ApplicationGroups\azuredeploy.parameters.Cantor-bo-apps.json `
    -Verbose -Force

# New-FOAppGroup 
New-AzResourceGroupDeployment `
    -ResourceGroupName $FOresourceGroup `
    -TemplateFile .\ApplicationGroups\azuredeploy.json `
    -TemplateParameterFile .\ApplicationGroups\azuredeploy.parameters.Cantor-fo-apps.json `
    -Verbose -Force

# New-ITAppGroup 
New-AzResourceGroupDeployment `
    -ResourceGroupName $ITresourceGroup `
    -TemplateFile .\ApplicationGroups\azuredeploy.json `
    -TemplateParameterFile .\ApplicationGroups\azuredeploy.parameters.Cantor-it-apps.json `
    -Verbose -Force

# New-DevsAppGroup 
New-AzResourceGroupDeployment `
    -ResourceGroupName $DevsresourceGroup `
    -TemplateFile .\ApplicationGroups\azuredeploy.json `
    -TemplateParameterFile .\ApplicationGroups\azuredeploy.parameters.Cantor-devs-apps.json `
    -Verbose -Force

# New-VIPAppGroup 
New-AzResourceGroupDeployment `
    -ResourceGroupName $VipresourceGroup `
    -TemplateFile .\ApplicationGroups\azuredeploy.json `
    -TemplateParameterFile .\ApplicationGroups\azuredeploy.parameters.Cantor-vip-apps.json `
    -Verbose -Force    
#==============================================================================
# Create WVD SessionHosts
#==============================================================================

# New-ValidationSessionHosts 
New-AzResourceGroupDeployment `
    -ResourceGroupName $VALresourceGroup `
    -TemplateFile .\SessionHosts\azuredeploy.json `
    -TemplateParameterFile .\SessionHosts\azuredeploy.parameters.Cantor-val-sh.json `
    -Verbose -Force

# New-BackOfficeSessionHosts 
New-AzResourceGroupDeployment `
    -ResourceGroupName $BOresourceGroup `
    -TemplateFile .\SessionHosts\azuredeploy.json `
    -TemplateParameterFile .\SessionHosts\azuredeploy.parameters.Cantor-bo-sh.json `
    -Verbose -Force

# New-FrontOfficeSessionHosts 
New-AzResourceGroupDeployment `
    -ResourceGroupName $FOresourceGroup `
    -TemplateFile .\SessionHosts\azuredeploy.json `
    -TemplateParameterFile .\SessionHosts\azuredeploy.parameters.Cantor-fo-sh.json `
    -Verbose -Force

# New-NfmSessionHosts 
New-AzResourceGroupDeployment `
    -ResourceGroupName $ITresourceGroup `
    -TemplateFile .\SessionHosts\azuredeploy.json `
    -TemplateParameterFile .\SessionHosts\azuredeploy.parameters.Cantor-it-sh.json `
    -Verbose -Force

# New-ProSessionHosts 
New-AzResourceGroupDeployment `
    -ResourceGroupName $PROresourceGroup `
    -TemplateFile .\SessionHosts\azuredeploy.json `
    -TemplateParameterFile .\SessionHosts\azuredeploy.parameters.Cantor-pro-sh-prd.json `
    -Verbose -Force
