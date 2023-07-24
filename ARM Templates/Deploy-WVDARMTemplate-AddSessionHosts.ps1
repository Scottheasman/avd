
<#
==============================================================================

*********** WVD Implementation for Cantor ************

File:      Deploy-WVDARMTemplate-AddSessionHosts.ps1
Author:    

Purpose:   Deploys additional session hosts to existing HostPool
           

This script is provided "AS IS" with no warranties, confers no rights and 
is not supported by the authors. 

==============================================================================
#>

# Set Subscription
$subscriptionId = "4fe83d79-cc9d-484f-bf8a-803ec70bac45"
Select-AzSubscription -SubscriptionId $subscriptionId

#==============================================================================
# Variable Declaration
#==============================================================================

# Set ARM Template Root Path
Set-Location "Z:\Azure Devops\b\CFAVDSept2021\WVD\ARM Templates"

# Set HostPool RG
$ResourceGroup = "uks-rg-avd-dec2-hp"
# Set the New 3 Letter Resource Designation Group and Resource Environment
# Should match the 3 letters you renamed your params file with (i.e. GEN, STD, ITA, etc))
$grp = "dec2"
$env = "prd"
#==============================================================================
# Create WVD SessionHosts
#==============================================================================

# New-SessionHosts 
New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroup `
    -TemplateFile .\SessionHosts\azuredeploy.json `
    -TemplateParameterFile .\SessionHosts\azuredeploy.parameters.Cantor-"$grp"-sh.json `
    -Verbose `
    -Force
