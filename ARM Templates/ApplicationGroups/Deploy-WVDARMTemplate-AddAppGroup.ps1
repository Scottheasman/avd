<#
==============================================================================

*********** WVD Implementation for NKF ************

File:      Deploy-WVDARMTemplate-AddAppGroup.ps1
Author:    Marc Graham - CTGlobal

Purpose:   Deploys AppGroup and assigns to existing WorkSPace
           

This script is provided "AS IS" with no warranties, confers no rights and 
is not supported by the authors. 

==============================================================================
#>

# Set Subscription
$subscriptionId = "5ee8486e-04dd-4847-b5ba-30a71888fe9c"
Select-AzSubscription -SubscriptionId $subscriptionId

#==============================================================================
# Variable Declaration
#==============================================================================

# Set ARM Template Root Path
Set-Location "C:\WVD"

# Set HostPool RG
$ResourceGroup = "eus2-rg-wvd-ita-hp-prd"

# Set the New 3 Letter Resource Designation Group 
# Should match the 3 letters you renamed your params file with (i.e. GEN, STD, ITA, etc))
$grp = "ita"

#==============================================================================
# Create WVD AppGroup and Assign to WorkSpace
#==============================================================================

# New-AppGroup
New-AzResourceGroupDeployment `
    -ResourceGroupName $resourceGroup `
    -TemplateFile .\ApplicationGroups\azuredeploy.json `
    -TemplateParameterFile .\ApplicationGroups\azuredeploy.parameters.NKF-"$grp"t-app-dev.json `
    -Verbose -Force

    