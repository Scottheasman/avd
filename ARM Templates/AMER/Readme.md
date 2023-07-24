


# **WVD Implementation for Cantor**

## This section describes manually running each section to create a new Azure Virtual Desktop deployment.

| File Name                                           | Description                                           | Command                                                                                                                                                                          |
|-----------------------------------------------------|-------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| wvd\amer\hostpools\azuredeploy.json                 | Host pool deployment template file                    | change directory to .\wvd\amer\hostpools<br>New-AzResourceGroupDeployment -ResourceGroupName eus2-rg-avd-bo-hp -TemplateFile .\azuredeploy.json -TemplateParameterFile .\azuredeploy.parameters.bo-hp.json -Verbose -Force |
| wvd\amer\hostpools\azuredeploy-bo-hp.json           | Host pool deployment template parameter file          | used in the above command.                                                                                                                                                       |
| wvd\amer\applicationgroups\azuredeploy.json         | Application group deployment template file            | change directory to .\wvd\amer\applicationgroups<br>New-AzResourceGroupDeployment -ResourceGroupName eus2-rg-avd-bo-hp -TemplateFile .\azuredeploy.json -TemplateParameterFile .\azuredeploy.parameters.bo-apps.json -Verbose -Force |
| wvd\amer\applicationgroups\azuredeploy-bo-apps.json | Application groups deployment template parameter file | used in the above command.                                                                                                                                                       |
| wvd\amer\sessionhosts\azuredeploy.json              | Session host deployment template file                 | change directory to .\wvd\amer\hostpools<br>New-AzResourceGroupDeployment -ResourceGroupName eus2-rg-avd-bo-hp -TemplateFile .\azuredeploy.json -TemplateParameterFile .\azuredeploy.parameters.bo-sh.json -Verbose -Force |
| wvd\amer\sessionhosts\azuredeploy-bo-sh.json        | Session hosts deployment template parameter file      | used in the above command.                                                                                                                                                       |

                      
These files reference the use of "BO" (back office) name for host pools, application groups and session hosts. This will should be substituted for the required name for your deployment.
In addition the path to the files may change, depending on where you clone the code to.

## **Step 1**
Create resource groups:

This command creates a resource group to store the AVD Workspace. This is only required if the Workspace you want to reference doesn't already exist.
```powershell
New-AzResourceGroup `
    -Name eus2-rg-avd-services `
    -Location eastus2 `
    -Verbose
    
```

This command creates a resource group to store the Session host AVD objects. Each set of session hosts need to be located in their own Resource Group
```powershell
New-AzResourceGroup `
    -Name eus2-rg-avd-bo-hp `
    -Location eastus2 `
    -Verbose
```    
 
 

## **Step 2**
## Create AVD Back Office HostPool

```powershell
New-AzResourceGroupDeployment `
    -ResourceGroupName eus2-rg-avd-bo-hp`
    -TemplateFile .\HostPools\azuredeploy.json `
    -TemplateParameterFile .\HostPools\azuredeploy.parameters.bo-hp.json `
    -Verbose `
    -Force
```
## **Step 3**
## Create AVD Back Office Application Group

```powershell
New-AzResourceGroupDeployment `
    -ResourceGroupName eus2-rg-avd-bo-hp`
    -TemplateFile .\ApplicationGroups\azuredeploy.json `
    -TemplateParameterFile .\ApplicationGroups\azuredeploy.parameters.bo-apps.json `
    -Verbose `
    -Force
```
## **Step 4**
## Create AVD Back Office Session hosts

```powershell
New-AzResourceGroupDeployment `
    -ResourceGroupName eus2-rg-avd-bo-hp`
    -TemplateFile .\SessionHosts\azuredeploy.json `
    -TemplateParameterFile .\SessionHosts\azuredeploy.parameters.bo-sh.json `
    -Verbose `
    -Force
```




# **Deployong a new host pool**

## This section describes using one command to deploy a new host pool.




| File Name                                           | Description                                           | Command                                                                                                                                                                          |
|-----------------------------------------------------|-------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| wvd\amer\Deploy-AVDTemplate-NewHostPool.ps1                | Deploy a new Host pool complete with Hostpool, App Groups and Session Hosts with one command.     | .\Deploy-AVDTemplate-NewHostPool.ps1  |


## Deploy-AVDTemplate-NewHostPool.ps1

```powershell
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

# Set Subscription to bgc-amer-infrastructure-prod
$subscriptionId = "a7b50fa6-5f5f-49b4-aa1c-128242d19284"
Select-AzSubscription -SubscriptionId $subscriptionId

# Set ARM Template Root Path. This is the location you have cloned the repo too.
Set-Location "Z:\Azure Devops\b\CFAVDSept2021\WVD\ARM Templates"

# Set Azure Resource Location
# Get-AzLocation | sort-object location | ft Location, Displayname
# = "East US 2"
$Location = "eastus2"

# Set HostPool resourcegroup name where avd vm objects will be deployed to.
#us $ITresourceGroup = "eus2-rg-wvd-ews-hp"
$AVDresourceGroup = "eus2-rg-avd-bo-hp"

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
# Create AVD HostPools
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
    -TemplateParameterFile .\HostPools\azuredeploy.parameters."$grp"-hp.json `
    -Verbose `
    -Force

#==============================================================================
# Create AVD AppGroups
#==============================================================================

# New-IT Production App Group 
New-AzResourceGroupDeployment `
    -ResourceGroupName $AVDresourceGroup `
    -TemplateFile .\ApplicationGroups\azuredeploy.json `
    -TemplateParameterFile .\ApplicationGroups\azuredeploy.parameters."$grp"-apps.json `
    -Verbose `
    -Force

#==============================================================================
# Create AVD SessionHosts
#==============================================================================

# New-IT Production Session Hosts 
New-AzResourceGroupDeployment `
    -ResourceGroupName $AVDresourceGroup `
    -TemplateFile .\SessionHosts\azuredeploy.json `
    -TemplateParameterFile .\SessionHosts\azuredeploy.parameters."$grp"-sh.json `
    -Verbose `
    -Force

```

## HostPool Deployment template file

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "hostpoolName": {
      "type": "string",
      "metadata": {
        "description": "The name of the Hostpool to be created."
      }
    },
    "hostpoolFriendlyName": {
      "type": "string",
      "metadata": {
        "description": "The friendly name of the Hostpool to be created."
      }
    },
    "hostpoolDescription": {
      "type": "string",
      "metadata": {
        "description": "The description of the Hostpool to be created."
      }
    },
    "hostpoolType": {
      "type": "string",
      "allowedValues": [
        "Personal",
        "Pooled"
      ],
      "metadata": {
        "description": "Set this parameter to Personal if you would like to enable Persistent Desktop experience. Defaults to false."
      }
    },
    "personalDesktopAssignmentType": {
      "type": "string",
      "allowedValues": [
        "Automatic",
        "Direct"
      ],
      "metadata": {
        "description": "Set the type of assignment for a Personal hostpool type"
      },
      "defaultValue": "Automatic"
    },
    "maxSessionLimit": {
      "type": "int",
      "metadata": {
        "description": "Maximum number of sessions."
      },
      "defaultValue": 99999
    },
    "loadBalancerType": {
      "type": "string",
      "allowedValues": [
        "BreadthFirst",
        "DepthFirst",
        "Persistent"
      ],
      "metadata": {
        "description": "Type of load balancer algorithm."
      },
      "defaultValue": "DepthFirst"
    },
    "customRdpProperty": {
      "type": "string",
      "metadata": {
        "description": "Hostpool rdp properties"
      },
      "defaultValue": "drivestoredirect:s:;redirectclipboard:i:1;"
    },
    "validationEnvironment": {
      "type": "bool",
      "metadata": {
        "description": "Whether to use the hostpool as a validation enviroment."
      },
      "defaultValue": false
    },
    "preferredAppGroupType": {
      "type": "string",
      "metadata": {
        "description": "Preferred App Group type to display"
      },
      "defaultValue": "Desktop"
    },
    "createDesktopAppGroup": {
      "type": "bool",
      "metadata": {
        "description": "Create desktop application group?"
      }
    },
    "userAssignments": {
      "type": "array",
      "metadata": {
        "description": "Array list of object ids to assign 'Desktop Virtualization User' on the app group"
      },
      "defaultValue": []
    },
    "workspaceResourceId": {
      "type": "string",
      "metadata": {
        "description": "The ResourceId of the Workspace."
      }
    },
    "logAnalyticsWorkSpaceId": {
      "type": "string",
      "metadata": {
        "description": "The resourceId of the logAnalyticsWorkSpace to send data to"
      }
    },
    "tokenValidityLength": {
      "defaultValue": "P30D",
      "type": "string",
      "metadata": {
        "description": "Optional. Host Pool token validity length. Usage: 'PT8H' - valid for 8 hours; 'P5D' - valid for 5 days; . When not provided, the token will be valid for 8 hours. Max 30 days"
      }
    },
    "baseTime": {
      "type": "string",
      "defaultValue": "[utcNow('u')]",
      "metadata": {
        "description": "Generated. Do not provide a value! This date value is used to generate a registration token."
      }
    },
    "location": {
      "defaultValue": "[resourceGroup().location]",
      "type": "string",
      "metadata": {
        "description": "The location where the resources will be deployed."
      }
    }
  },
  "variables": {
    "hostpoolName": "[parameters('hostpoolName')]",
    "hostpoolFriendlyName": "[parameters('hostpoolFriendlyName')]",
    "hostpoolDescription": "[parameters('hostpoolDescription')]",
    "hostpoolType": "[parameters('hostpoolType')]",
    "customRdpProperty": "[parameters('customRdpProperty')]",
    "personalDesktopAssignmentType": "[parameters('personalDesktopAssignmentType')]",
    "maxSessionLimit": "[parameters('maxSessionLimit')]",
    "loadBalancerType": "[parameters('loadBalancerType')]",
    "validationEnvironment": "[parameters('validationEnvironment')]",
    "preferredAppGroupType": "[parameters('preferredAppGroupType')]",
    "desktopAppGroupName": "[concat(variables('hostpoolName'),'-DAG')]",
    "tokenExpirationTime": "[dateTimeAdd(parameters('baseTime'), parameters('tokenValidityLength'))]",
    "appGroupResourceId": "[resourceId('Microsoft.DesktopVirtualization/applicationgroups', variables('desktopAppGroupName'))]",
    "desktopVirtualizationUserRoleDefinition": "[resourceId('Microsoft.Authorization/roleDefinitions/', '1d18fff3-a72a-46b5-b4a9-0b38a3cd7e63')]",
    "workspaceSubscriptionId": "[split(parameters('workspaceResourceId'), '/')[2]]",
    "workspaceResourceGroup": "[split(parameters('workspaceResourceId'), '/')[4]]",
    "workspaceName": "[split(parameters('workspaceResourceId'), '/')[8]]"
  },
  "resources": [
    {
      "type": "Microsoft.DesktopVirtualization/hostpools",
      "apiVersion": "2020-10-19-preview",
      "name": "[variables('hostpoolName')]",
      "location": "[parameters('location')]",
      "properties": {
        "friendlyName": "[variables('hostpoolFriendlyName')]",
        "description": "[variables('hostpoolDescription')]",
        "hostPoolType": "[variables('hostpoolType')]",
        "customRdpProperty": "[variables('customRdpProperty')]",
        "personalDesktopAssignmentType": "[variables('personalDesktopAssignmentType')]",
        "maxSessionLimit": "[variables('maxSessionLimit')]",
        "loadBalancerType": "[variables('loadBalancerType')]",
        "validationEnvironment": "[variables('validationEnvironment')]",
        "preferredAppGroupType": "[variables('preferredAppGroupType')]",
        "registrationInfo": {
          "expirationTime": "[variables('tokenExpirationTime')]",
          "registrationTokenOperation": "Update"
        }
      }
    },
    {
      "type": "Microsoft.DesktopVirtualization/applicationgroups",
      "apiVersion": "2020-10-19-preview",
      "name": "[variables('desktopAppGroupName')]",
      "location": "[parameters('location')]",
      "condition": "[parameters('createDesktopAppGroup')]",
      "dependsOn": [
        "[resourceId('Microsoft.DesktopVirtualization/hostpools/', parameters('hostpoolName'))]"
      ],
      "properties": {
        "hostpoolarmpath": "[resourceId('Microsoft.DesktopVirtualization/hostpools/', parameters('hostpoolName'))]",
        "friendlyName": "Default Desktop",
        "description": "Default Desktop Application Group",
        "applicationGroupType": "Desktop"
      }
    },

    {
      "type": "Microsoft.Resources/deployments",
      "apiVersion": "2020-06-01",
      "name": "[concat('linkedTemplate-', variables('hostpoolName'), '-', replace(variables('desktopAppGroupName'), ' ', ''))]",
      "condition": "[parameters('createDesktopAppGroup')]",
      "subscriptionId": "[variables('workspaceSubscriptionId')]",
      "resourceGroup": "[variables('workspaceResourceGroup')]",
      "dependsOn": [
        "[resourceId('Microsoft.DesktopVirtualization/applicationgroups', variables('desktopAppGroupName'))]"
      ],
      "properties": {
        "mode": "Incremental",
        "template": {
          "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
          "contentVersion": "1.0.0.0",
          "resources": [
            {
              "type": "Microsoft.DesktopVirtualization/workspaces",
              "apiVersion": "2020-10-19-preview",
              "name": "[variables('workspaceName')]",
              "location": "[reference(resourceId(variables('workspaceSubscriptionId'), variables('workspaceResourceGroup'), 'Microsoft.DesktopVirtualization/workspaces', variables('workspaceName')),'2020-10-19-preview','Full').location]",
              "condition": "[not(greater(indexOf(string(reference(resourceId(variables('workspaceSubscriptionId'), variables('workspaceResourceGroup'), 'Microsoft.DesktopVirtualization/workspaces', variables('workspaceName')),'2020-10-19-preview','Full').properties.applicationGroupReferences), variables('appGroupResourceId')),0))]",
              "properties": {
                "applicationGroupReferences": "[union(reference(resourceId(variables('workspaceSubscriptionId'), variables('workspaceResourceGroup'), 'Microsoft.DesktopVirtualization/workspaces', variables('workspaceName')),'2020-10-19-preview','Full').properties.applicationGroupReferences, array(variables('appGroupResourceId')))]"
              }
            }
          ]
        }
      }
    },
    {
      "type": "Microsoft.DesktopVirtualization/applicationgroups/providers/roleAssignments",
      "apiVersion": "2020-04-01-preview",
      "name": "[if(and(greater(length(parameters('userAssignments')), 0), parameters('createDesktopAppGroup')),concat(variables('desktopAppGroupName'), '/Microsoft.Authorization/', guid(variables('appGroupResourceId'), variables('desktopVirtualizationUserRoleDefinition'), parameters('userAssignments')[copyIndex('role-assignments-loop')])), concat(variables('desktopAppGroupName'), '/Microsoft.Authorization/', guid('FakeName')))]",
      "dependsOn": [
        "[resourceId('Microsoft.DesktopVirtualization/applicationgroups', variables('desktopAppGroupName'))]"
      ],
      "condition": "[and(greater(length(parameters('userAssignments')), 0), parameters('createDesktopAppGroup'))]",
      "copy": {
        "name": "role-assignments-loop",
        "count": "[length(parameters('userAssignments'))]"
      },
      "properties": {
        "principalId": "[parameters('userAssignments')[CopyIndex('role-assignments-loop')]]",
        "roleDefinitionId": "[variables('desktopVirtualizationUserRoleDefinition')]"
      }
    },
    {
      "type": "Microsoft.DesktopVirtualization/hostpools/providers/diagnosticsettings",
      "name": "[concat(variables('hostpoolName'), '/Microsoft.Insights/service')]",
      "apiVersion": "2017-05-01-preview",
      "dependsOn": [
        "[resourceId('Microsoft.DesktopVirtualization/hostpools/', variables('hostPoolName'))]"
      ],
      "properties": {
        "workspaceId": "[parameters('logAnalyticsWorkSpaceId')]",
        "logs": [
          {
            "category": "Checkpoint",
            "enabled": true
          },
          {
            "category": "Error",
            "enabled": true
          },
          {
            "category": "Management",
            "enabled": true
          },
          {
            "category": "Connection",
            "enabled": true
          },
          {
            "category": "HostRegistration",
            "enabled": true
          }
        ]
      }
    },
    {
      "type": "Microsoft.DesktopVirtualization/applicationgroups/providers/diagnosticsettings",
      "name": "[concat(variables('desktopAppGroupName'), '/Microsoft.Insights/service')]",
      "apiVersion": "2017-05-01-preview",
      "dependsOn": [
        "[resourceId('Microsoft.DesktopVirtualization/applicationgroups', variables('desktopAppGroupName'))]"
      ],
      "condition": "[parameters('createDesktopAppGroup')]",
      "properties": {
        "workspaceId": "[parameters('logAnalyticsWorkSpaceId')]",
        "logs": [
          {
            "category": "Checkpoint",
            "enabled": true
          },
          {
            "category": "Error",
            "enabled": true
          },
          {
            "category": "Management",
            "enabled": true
          }
        ]
      }
    }
  ],
  "outputs": {
  }
}
```

## HostPool Deployment template parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "hostpoolName": {
            "value": "eus2-avd-bo-hp"
        },
        "hostpoolFriendlyName": {
            "value": "Cantor AMER Back Office HostPool"
        },
        "hostpoolDescription": {
            "value": "Cantor AMER Back Office HostPool"
        },
        "location": {
            "value": "eastus2"
        },
        "hostpoolType": {
            "value": "Pooled"
        },
        "maxSessionLimit": {
            "value": 10
        },
        "loadBalancerType": {
            "value": "DepthFirst"
        },
        "validationEnvironment": {
            "value": false
        },
        "workspaceResourceId": {
            "value": "/subscriptions/a7b50fa6-5f5f-49b4-aa1c-128242d19284/resourceGroups/eus2-rg-avd-services/providers/Microsoft.DesktopVirtualization/workspaces/eus2-avd-ws-production"
        },
        "logAnalyticsWorkSpaceId": {
            "value": "/subscriptions/65248a74-84e8-46d6-b373-01a13b664a20/resourcegroups/loganalytics/providers/microsoft.operationalinsights/workspaces/bgcloganalytics"
        },
        "createDesktopAppGroup": {
            "value": false
        }
    }
}
```

## Application Group Deployment template file

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "appGroupName": {
      "type": "string",
      "minLength": 1,
      "metadata": {
        "description": "Required. Name of the AVD Application Group."
      }
    },
     "location": {
      "type": "string",
      "defaultValue": "[resourceGroup().location]",
      "metadata": {
        "description": "Optional. Location for all resources."
      }
    },
    "appGroupType": {
      "allowedValues": [
        "RemoteApp",
        "Desktop"
      ],
      "type": "string",
      "metadata": {
        "description": "Required. The type of the Application Group to be created. Allowed values: RemoteApp or Desktop"
      }
    },
    "hostpoolName": {
      "type": "string",
      "defaultValue": [],
      "metadata": {
        "description": "Required. Name of the Host Pool to be linked to this Application Group."
      }
    },
    "appGroupFriendlyName": {
      "defaultValue": "",
      "type": "string",
      "metadata": {
        "description": "Optional. The friendly name of the Application Group to be created."
      }
    },
    "appGroupDescription": {
      "defaultValue": "",
      "type": "string",
      "metadata": {
        "description": "Optional. The description of the Application Group to be created."
      }
    },
    "workspaceResourceId": {
      "type": "string",
      "metadata": {
        "description": "The resourceId of the Workspace."
      }
    },
    "logAnalyticsWorkSpaceId": {
      "type": "string",
      "metadata": {
        "description": "The resourceId of the logAnalyticsWorkSpace to send data to"
      }
    },
      "resourceTags": {
      "type": "object",
      "defaultValue": {
          "ApplicationId": "",
          "ApplicationName": "",
          "ApplicationOwner": "",
          "CostCode": "",
          "DataProfile": "",
          "Department": "",
          "Description": "",
          "Entity": "",
          "Environment": "",
          "GLCode": "",
          "ProjectName": "",
          "ServiceReviewDate": ""
      }      
    }
  },
  "variables": {
    "appGroupResourceId": "[resourceId('Microsoft.DesktopVirtualization/applicationgroups', parameters('appGroupName'))]",
    "workspaceSubscriptionId": "[split(parameters('workspaceResourceId'), '/')[2]]",
    "workspaceResourceGroup": "[split(parameters('workspaceResourceId'), '/')[4]]",
    "workspaceName": "[split(parameters('workspaceResourceId'), '/')[8]]"
  },
  "resources": [
    {
      "type": "Microsoft.DesktopVirtualization/applicationgroups",
      "apiVersion": "2020-10-19-preview",
      "name": "[parameters('appGroupName')]",
      "location": "[parameters('location')]",
      "tags": "[parameters('resourceTags')]",
      "properties": {
        "hostpoolarmpath": "[resourceId('Microsoft.DesktopVirtualization/hostpools/', parameters('hostpoolName'))]",
        "friendlyName": "[parameters('appGroupFriendlyName')]",
        "description": "[parameters('appGroupDescription')]",
        "applicationGroupType": "[parameters('appGroupType')]"
      }
    },
    {
      "type": "Microsoft.Resources/deployments",
      "apiVersion": "2020-06-01",
      "name": "[concat(parameters('hostpoolName'), '-', replace(parameters('appGroupName'), ' ', ''))]",
      "subscriptionId": "[variables('workspaceSubscriptionId')]",
      "resourceGroup": "[variables('workspaceResourceGroup')]",
      "dependsOn": [
        "[resourceId('Microsoft.DesktopVirtualization/applicationgroups', parameters('appGroupName'))]"
      ],
      "properties": {
        "mode": "Incremental",
        "template": {
          "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
          "contentVersion": "1.0.0.0",
          "resources": [
            {
              "type": "Microsoft.DesktopVirtualization/workspaces",
              "apiVersion": "2020-10-19-preview",
              "name": "[variables('workspaceName')]",
              "location": "[parameters('location')]",
              "condition": "[not(greater(indexOf(string(reference(resourceId(variables('workspaceSubscriptionId'), variables('workspaceResourceGroup'), 'Microsoft.DesktopVirtualization/workspaces', variables('workspaceName')),'2020-10-19-preview','Full').properties.applicationGroupReferences), variables('appGroupResourceId')),0))]",
              "properties": {
                "applicationGroupReferences": "[union(reference(resourceId(variables('workspaceSubscriptionId'), variables('workspaceResourceGroup'), 'Microsoft.DesktopVirtualization/workspaces', variables('workspaceName')),'2020-10-19-preview','Full').properties.applicationGroupReferences, array(variables('appGroupResourceId')))]"
              }
            }
          ]
        }
      }
    },
    {
      "type": "Microsoft.DesktopVirtualization/applicationgroups/providers/diagnosticsettings",
      "name": "[concat(parameters('appGroupName'), '/Microsoft.Insights/service')]",
      "apiVersion": "2017-05-01-preview",
      "tags": "[parameters('resourceTags')]",
      "dependson": [
        "[resourceId('Microsoft.DesktopVirtualization/applicationgroups', parameters('appGroupName'))]"
      ],
      "properties": {
        "workspaceId": "[parameters('logAnalyticsWorkSpaceId')]",
        "logs": [
          {
            "category": "Checkpoint",
            "enabled": true
          },
          {
            "category": "Error",
            "enabled": true
          },
          {
            "category": "Management",
            "enabled": true
          }
        ]
      }
    }
  ]
}

```

## Application Group Deployment template parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "appGroupName": {
            "value": "AMER Back Office User Applications"
        },
        "location": {
            "value": "eastus2"
        },
        "appGroupType": {
            "value": "RemoteApp"
        },
        "hostpoolName": {
            "value": "eus2-avd-bo-hp"
        },
        "appGroupFriendlyName": {
            "value": "AMER Back Office User Applications"
        },
        "appGroupDescription": {
            "value": "AMER Back Office HostPool"
        },
        "workspaceResourceId": {
            "value": "/subscriptions/a7b50fa6-5f5f-49b4-aa1c-128242d19284/resourceGroups/eus2-rg-avd-services/providers/Microsoft.DesktopVirtualization/workspaces/eus2-avd-ws-production"
        },
        "logAnalyticsWorkSpaceId": {
            "value": "/subscriptions/65248a74-84e8-46d6-b373-01a13b664a20/resourcegroups/loganalytics/providers/microsoft.operationalinsights/workspaces/bgcloganalytics"
        }
    }
}
```

## Session Hosts Deployment template file

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "hostpoolName": {
      "type": "string",
      "metadata": {
        "description": "The name of the hostpool"
      }
    },
    "vmNamePrefix": {
      "type": "string",
      "metadata": {
        "description": "This prefix will be used in combination with the VM number to create the VM name. If using 'rdsh' as the prefix, VMs would be named 'rdsh-0', 'rdsh-1', etc. You should use a unique prefix to reduce name collisions in Active Directory."
      }
    },
    "vmInitialNumber": {
      "type": "int",
      "metadata": {
        "description": "VM name prefix initial number."
      },
      "defaultValue": 0
    },
    "rdshNumberOfInstances": {
      "type": "int",
      "metadata": {
        "description": "Number of session hosts that will be created and added to the hostpool."
      }
    },
    "rdshVmSize": {
      "type": "string",
      "metadata": {
        "description": "The size of the session host VMs."
      },
      "defaultValue": "Standard_A2"
    },
    "rdshImageSource": {
      "type": "string",
      "metadata": {
        "description": "Select the image source for the session host vms. VMs from a Gallery image will be created with Managed Disks."
      },
      "defaultValue": "SharedImageGallery"
    },
    "SharedImageGalleryResourceGroup": {
      "type": "string",
      "metadata": {
        "description": "(Required when rdshImageSrouce = SharedImageGallery) ResourceGroup name of the Shared Image Gallery"
      },
      "defaultValue": ""
    },
    "SharedImageGalleryName": {
      "type": "string",
      "metadata": {
        "description": "(Required when rdshImageSrouce = SharedImageGallery) Name of the Shared Image Gallery."
      },
      "defaultValue": ""
    },
    "SharedImageGalleryVersionName": {
      "type": "string",
      "metadata": {
        "description": "(Required when rdshImageSrouce = SharedImageGallery) Name of the Image Version - should follow <MajorVersion>.<MinorVersion>.<Patch>."
      },
      "defaultValue": ""
    },
    "SharedImageGalleryDefinitionName": {
      "type": "string",
      "metadata": {
        "description": "(Required when rdshImageSrouce = SharedImageGallery) Name of the Image Definition."
      },
      "defaultValue": ""
    },
    "subnetResourceId": {
      "type": "string",
      "metadata": {
        "description": "The unique id of the subnet for the nics."
      }
    },
    "domainToJoin": {
      "type": "string",
      "defaultValue": "ngad.local",
      "metadata": {
        "description": "The FQDN of the AD domain"
      }
    },
    "ouPath": {
      "type": "string",
      "metadata": {
        "description": "OUPath for the domain join"
      },
      "defaultValue": ""
    },
    "domainJoinUsername": {
      "type": "string",
      "metadata": {
        "description": "Username for the account on the domain"
      }
    },
    "domainJoinPassword": {
      "type": "securestring",
      "metadata": {
        "description": "Password for the account on the domain"
      }
    },
    "adminPassword": {
      "type": "securestring",
      "metadata": {
        "description": "Password for the Virtual Machine."
      }
    },
    "rdshGalleryImageSKU": {
      "type": "string",
      "metadata": {
        "description": "(Required when rdshImageSource = Gallery) Gallery image SKU. Values without a numeric suffix, such as 1903, will use the latest release available in this template."
      },
      "defaultValue": "Windows-10-Enterprise-multi-session-with-Office-365-ProPlus"
    },
    "rdshCustomImageSourceName": {
      "type": "string",
      "defaultValue": "",
      "metadata": {
        "description": "(Required when rdshImageSource = CustomImage) Name of the managed disk."
      }
    },
    "rdshCustomImageSourceResourceGroup": {
      "type": "string",
      "defaultValue": "",
      "metadata": {
        "description": "(Required when rdshImageSource = CustomImage) Resource group name for the managed disk, if you choose to provide one."
      }
    },
    "rdshVMDiskType": {
      "type": "string",
      "allowedValues": [
        "Premium_LRS",
        "StandardSSD_LRS",
        "Standard_LRS"
      ],
      "defaultValue": "StandardSSD_LRS",
      "metadata": {
        "description": "The VM disk type for the VM: HDD or SSD."
      }
    },
    "enableAcceleratedNetworking": {
      "type": "bool",
      "metadata": {
        "description": "Enables Accelerated Networking feature, notice that VM size must support it, this is supported in most of general purpose and compute-optimized instances with 2 or more vCPUs, on instances that supports hyperthreading it is required minimum of 4 vCPUs."
      },
      "defaultValue": false
    },
    "adminUsername": {
      "type": "string",
      "defaultValue": "winteladm",
      "metadata": {
        "description": "Username for the Virtual Machine."
      }
    },
    "createNetworkSecurityGroup": {
      "type": "bool",
      "metadata": {
        "description": "Whether to create a new network security group or use an existing one"
      },
      "defaultValue": false
    },
    "networkSecurityGroupId": {
      "type": "string",
      "metadata": {
        "description": "The resource id of an existing network security group"
      },
      "defaultValue": ""
    },
    "networkSecurityGroupRules": {
      "type": "array",
      "metadata": {
        "description": "The rules to be given to the new network security group"
      },
      "defaultValue": []
    },
    "availabilitySetsId": {
      "type": "string",
      "metadata": {
        "description": "The resource id of an existing availability set"
      },
      "defaultValue": ""
    },

    "artifactsLocation": {
      "type": "string",
      "metadata": {
        "description": "The base URI where artifacts required by this template are located."
      },
      "defaultValue": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration.zip"
    },
    "location": {
      "type": "string",
      "defaultValue": "[resourceGroup().location]",
      "metadata": {
        "description": "Location for all resources to be created in."
      }
    },
    "logAnalyticsWorkSpaceId": {
      "type": "string",
      "defaultValue": "/subscriptions/65248a74-84e8-46d6-b373-01a13b664a20/resourcegroups/loganalytics/providers/microsoft.operationalinsights/workspaces/bgcloganalytics",
      "metadata": {
        "description": "The resourceId of the logAnalyticsWorkSpace to send data to"
      }
    },
    "resourceTags": {
      "type": "object",
      "defaultValue": {
        "ApplicationName": "",
        "ApplicationOwner": "",
        "CostCode": "",
        "DataProfile": "",
        "Department": "",
        "Description": "",
        "Entity": "",
        "Environment": "",
        "GLCode": "",
        "ProjectName": "",
        "ServiceReviewDate": "",
        "AppID": ""
      }
    }
  },
  "variables": {
    "rdshPrefix": "[concat(parameters('vmNamePrefix'),'-')]",
    "apiVersion": "2015-06-15",
    "domainJoinOptions": 3,
    "storageAccountType": "[parameters('rdshVMDiskType')]",
    "newNsgName": "[concat(variables('rdshPrefix'), 'nsg')]",
    "nsgId": "[if(parameters('createNetworkSecurityGroup'), resourceId('Microsoft.Network/networkSecurityGroups', variables('newNsgName')), parameters('networkSecurityGroupId'))]",
    "avSetSKU": "Aligned",
    "galleryImage": {
      "Windows-10-Enterprise-multi-session-with-Office-365-ProPlus": {
        "publisher": "MicrosoftWindowsDesktop",
        "offer": "office-365",
        "sku": "20h1-evd-o365pp",
        "version": "latest"
      },
      "Windows-10-Enterprise-multi-session-with-Office-365-ProPlus-lower": {
        "publisher": "microsoftwindowsdesktop",
        "offer": "office-365",
        "sku": "20h1-evd-o365pp",
        "version": "latest"
      },
      "Windows-10-Enterprise-multi-session-with-Office-365-ProPlus-2004": {
        "publisher": "MicrosoftWindowsDesktop",
        "offer": "office-365",
        "sku": "20h1-evd-o365pp",
        "version": "latest"
      },
      "Windows-10-Enterprise-multi-session-with-Office-365-ProPlus-1909": {
        "publisher": "MicrosoftWindowsDesktop",
        "offer": "office-365",
        "sku": "19h2-evd-o365pp",
        "version": "latest"
      },
      "Windows-10-Enterprise-multi-session-with-Office-365-ProPlus-1903": {
        "publisher": "MicrosoftWindowsDesktop",
        "offer": "office-365",
        "sku": "1903-evd-o365pp",
        "version": "latest"
      },
      "Windows-10-Enterprise-multi-session": {
        "publisher": "MicrosoftWindowsDesktop",
        "offer": "Windows-10",
        "sku": "20h1-evd",
        "version": "latest"
      },
      "Windows-10-Enterprise-multi-session-2004": {
        "publisher": "MicrosoftWindowsDesktop",
        "offer": "Windows-10",
        "sku": "20h1-evd",
        "version": "latest"
      },
      "Windows-10-Enterprise-multi-session-1909": {
        "publisher": "MicrosoftWindowsDesktop",
        "offer": "Windows-10",
        "sku": "19h2-evd",
        "version": "latest"
      },
      "Windows-10-Enterprise-multi-session-1903": {
        "publisher": "MicrosoftWindowsDesktop",
        "offer": "Windows-10",
        "sku": "19h1-evd",
        "version": "latest"
      },
      "Windows-10-Enterprise-Latest": {
        "publisher": "MicrosoftWindowsDesktop",
        "offer": "Windows-10",
        "sku": "20h1-ent",
        "version": "latest"
      },
      "Windows-10-Enterprise-2004": {
        "publisher": "MicrosoftWindowsDesktop",
        "offer": "Windows-10",
        "sku": "20h1-ent",
        "version": "latest"
      },
      "Windows-10-Enterprise-1909": {
        "publisher": "MicrosoftWindowsDesktop",
        "offer": "Windows-10",
        "sku": "19h2-ent",
        "version": "latest"
      },
      "Windows-10-Enterprise-1903": {
        "publisher": "MicrosoftWindowsDesktop",
        "offer": "Windows-10",
        "sku": "19h1-ent",
        "version": "latest"
      },
      "2016-Datacenter": {
        "publisher": "MicrosoftwindowsServer",
        "offer": "WindowsServer",
        "sku": "2016-Datacenter",
        "version": "latest"
      }
    },
    "imageName": "[concat(variables('rdshPrefix'), 'image')]",
    "VMImageReference": {
      "customimage": {
        "id": "[resourceId(parameters('rdshCustomImageSourceResourceGroup'), 'Microsoft.Compute/images', parameters('rdshCustomImageSourceName'))]"
        //"id": "subscriptions/a7b50fa6-5f5f-49b4-aa1c-128242d19284/resourceGroups/eus2-rg-sig/providers/Microsoft.Compute/galleries/eus2sig01/images/eus2sigwvd21h1v2"
      },
      "SharedImageGallery": {
        "id": "[resourceId(parameters('SharedImageGalleryResourceGroup'),'Microsoft.Compute/galleries/images/versions',parameters('SharedImageGalleryName'), parameters('SharedImageGalleryDefinitionName'), parameters('SharedImageGalleryVersionName') )]"
        //"id": "/subscriptions/a7b50fa6-5f5f-49b4-aa1c-128242d19284/resourceGroups/eus2-rg-sig/providers/Microsoft.Compute/galleries/eus2sig01/images/eus2sigwvd21h1v2/versions/0.24895.51910"
      },
      "gallery": "[variables('galleryimage')[parameters('rdshGalleryImageSKU')]]"
    },
    "rdshImageSourceLower": "[toLower(parameters('rdshImageSource'))]"
  },
  "functions": [
    {
      "namespace": "main",
      "members": {
        "getVMImageReferenceCustomVHD": {
          "parameters": [
            {
              "name": "imageName",
              "type": "string"
            }
          ],
          "output": {
            "type": "object",
            "value": {
              "id": "[resourceId('Microsoft.Compute/images', parameters('imageName'))]"
            }
          }
        }
      }
    }
  ],
  "resources": [
    {
      "apiVersion": "2019-07-01",
      "type": "Microsoft.Compute/availabilitySets",
      "name": "[concat(variables('rdshPrefix'), 'availabilitySet')]",
      "location": "[parameters('location')]",
      "tags": "[parameters('resourceTags')]",
      "condition": "[equals(parameters('availabilitySetsId'), '')]",
      "properties": {
        "platformUpdateDomainCount": 5,
        "platformFaultDomainCount": 2
      },
      "sku": {
        "name": "[variables('avSetSKU')]"
      }
    },
    {
      "condition": "[parameters('createNetworkSecurityGroup')]",
      "type": "Microsoft.Network/networkSecurityGroups",
      "apiVersion": "2020-05-01",
      "name": "[variables('newNsgName')]",
      "location": "[parameters('location')]",
      "tags": "[parameters('resourceTags')]",
      "properties": {
        "securityRules": "[parameters('networkSecurityGroupRules')]"
      }
    },
    {
      "apiVersion": "2020-05-01",
      "type": "Microsoft.Network/networkInterfaces",
      "name": "[concat(variables('rdshPrefix'), padLeft(add(copyindex(), parameters('vmInitialNumber')), 2, '0'), '-nic')]",
      "location": "[parameters('location')]",
      "tags": "[parameters('resourceTags')]",
      "dependsOn": [
        "[resourceId('Microsoft.Network/networkSecurityGroups',variables('newNsgName'))]"
      ],
      "copy": {
        "name": "rdsh-nic-loop",
        "count": "[parameters('rdshNumberOfInstances')]"
      },
      "properties": {
        "ipConfigurations": [
          {
            "name": "ipconfig",
            "properties": {
              "privateIPAllocationMethod": "Dynamic",
              "subnet": {
                "id": "[parameters('subnetResourceId')]"
              }
            }
          }
        ],
        "enableAcceleratedNetworking": "[parameters('enableAcceleratedNetworking')]",
        "networkSecurityGroup": "[if(empty(parameters('networkSecurityGroupId')), json('null'), json(concat('{\"id\": \"', variables('nsgId'), '\"}')))]"
      }
    },
    {
      "apiVersion": "2019-07-01",
      "type": "Microsoft.Compute/virtualMachines",
      "name": "[concat(variables('rdshPrefix'), padLeft(add(copyindex(), parameters('vmInitialNumber')), 2, '0'))]",
      "location": "[parameters('location')]",
      "tags": "[parameters('resourceTags')]",
      "copy": {
        "name": "rdsh-vm-loop",
        "count": "[parameters('rdshNumberOfInstances')]"
      },
      "dependsOn": [
        "[concat('Microsoft.Network/networkInterfaces/', variables('rdshPrefix'), padLeft(add(copyindex(), parameters('vmInitialNumber')), 2, '0'), '-nic')]"
      ],
      "properties": {
        "hardwareProfile": {
          "vmSize": "[parameters('rdshVmSize')]"
        },
        "availabilitySet": {
          "id": "[if(equals(parameters('availabilitySetsId'), ''), resourceId('Microsoft.Compute/availabilitySets',concat(variables('rdshPrefix'), 'availabilitySet')), parameters('availabilitySetsId'))]"
        },
        "osProfile": {
          "computerName": "[concat(variables('rdshPrefix'), padLeft(add(copyindex(), parameters('vmInitialNumber')), 2, '0'))]",
          "adminUsername": "[parameters('adminUsername')]",
          "adminPassword": "[parameters('adminPassword')]"
        },
        "storageProfile": {
          "imageReference": "[if(equals(variables('rdshImageSourceLower'), 'customvhd'), main.getVMImageReferenceCustomVHD(variables('imageName')), variables('VMImageReference')[variables('rdshImageSourceLower')])]",
          "osDisk": {
            "createOption": "FromImage",
            "managedDisk": {
              "storageAccountType": "[variables('storageAccountType')]"
            }
          }
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "[resourceId('Microsoft.Network/networkInterfaces',concat(variables('rdshPrefix'), padLeft(add(copyindex(), parameters('vmInitialNumber')), 2, '0'), '-nic'))]"
            }
          ]
        },
        "licenseType": "Windows_Client"
      }
    },
    {
      "apiVersion": "2019-07-01",
      "type": "Microsoft.Compute/virtualMachines/extensions",
      "name": "[concat(variables('rdshPrefix'), padLeft(add(copyindex(), parameters('vmInitialNumber')), 2, '0'), '/', 'joindomain')]",
      "location": "[parameters('location')]",
      "tags": "[parameters('resourceTags')]",
      "dependsOn": [
        "rdsh-vm-loop"
      ],
      "copy": {
        "name": "rdsh-domain-join-loop",
        "count": "[parameters('rdshNumberOfInstances')]"
      },
      "properties": {
        "publisher": "Microsoft.Compute",
        "type": "JsonADDomainExtension",
        "typeHandlerVersion": "1.3",
        "autoUpgradeMinorVersion": true,
        "settings": {
          "Name": "[parameters('domainToJoin')]",
          "OUPath": "[parameters('ouPath')]",
          "User": "[concat(parameters('domainToJoin'), '\\', parameters('domainJoinUsername'))]",
          "Restart": "true",
          "Options": "[variables('domainJoinOptions')]"
        },
        "protectedSettings": {
          "Password": "[parameters('domainJoinPassword')]"
        }
      }
    },
    {
      "type": "Microsoft.Compute/virtualMachines/extensions",
      "name": "[concat(variables('rdshPrefix'), padLeft(add(copyindex(), parameters('vmInitialNumber')), 2, '0'), '/', 'MMAExtension')]",
      "apiVersion": "2019-07-01",
      "location": "[parameters('location')]",
      "dependsOn": [
        "rdsh-domain-join-loop"
      ],
      "copy": {
        "name": "rdsh-mma-loop",
        "count": "[parameters('rdshNumberOfInstances')]"
      },
      "properties": {
        "publisher": "Microsoft.EnterpriseCloud.Monitoring",
        "type": "MicrosoftMonitoringAgent",
        "typeHandlerVersion": "1.0",
        "autoUpgradeMinorVersion": true,
        "settings": {
          "workspaceId": "[reference(parameters('logAnalyticsWorkSpaceId'), '2015-03-20').customerId]"
        },
        "protectedSettings": {
          "workspaceKey": "[listKeys(parameters('logAnalyticsWorkSpaceId'), '2015-03-20').primarySharedKey]"
        }
      }
    },
    {
      "apiVersion": "2019-07-01",
      "type": "Microsoft.Compute/virtualMachines/extensions",
      "name": "[concat(variables('rdshPrefix'), padLeft(add(copyindex(), parameters('vmInitialNumber')), 2, '0'), '/', 'dscextension')]",
      "location": "[parameters('location')]",
      "tags": "[parameters('resourceTags')]",
      "dependsOn": [
        "rdsh-mma-loop"
      ],
      "copy": {
        "name": "rdsh-dsc-loop",
        "count": "[parameters('rdshNumberOfInstances')]"
      },
      "properties": {
        "publisher": "Microsoft.Powershell",
        "type": "DSC",
        "typeHandlerVersion": "2.73",
        "autoUpgradeMinorVersion": true,
        "settings": {
          "modulesUrl": "[parameters('artifactsLocation')]",
          "configurationFunction": "Configuration.ps1\\AddSessionHost",
          "properties": {
            "hostPoolName": "[parameters('hostpoolName')]",
            "registrationInfoToken": "[reference(resourceId('Microsoft.DesktopVirtualization/hostpools', parameters('hostpoolName')), '2019-12-10-preview').registrationInfo.token]"
          }
        }
      }
    }
  ],
  "outputs": {}
}

```

## Session Hosts Deployment template parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "hostpoolName": {
            "value": "eus2-avd-bo-hp"
        },
        "vmNamePrefix": {
            "value": "eus2avdbo"
        },
        "vmInitialNumber": {
            "value": 1
        },
        "rdshNumberOfInstances": {
            "value": 5
        },
        "rdshVmSize": {
            "value": "Standard_D2as_v4"
        },
        "rdshImageSource": {
            "value": "SharedImageGallery"
        },
        "SharedImageGalleryResourceGroup": {
            "value": "eus2-rg-sig"
        },
        "SharedImageGalleryName": {
            "value": "eus2sig01"
        },
        "SharedImageGalleryVersionName": {
            "value": "latest"
        },
        "SharedImageGalleryDefinitionName": {
            "value": "eus2sigwvd21h1v2"
        },
        "subnetResourceId": {
            "value": "/subscriptions/a7b50fa6-5f5f-49b4-aa1c-128242d19284/resourceGroups/eus2-rg-wvd/providers/Microsoft.Network/virtualNetworks/eus2-vn-wvd/subnets/eus2-vn-wvd-sn-1"
        },
        "domainToJoin": {
            "value": "cad.local"
        },
        "ouPath": {
            "value": "OU=eus2-avd-bo-hp,OU=Hostpools,OU=eus2,OU=Azure WVD,DC=cad,DC=local"
        },
        "domainJoinUsername": {
            "value": "ser-azurewvd"
        },
        "domainJoinPassword": {
            "reference": {
                "keyVault": {
                    "id": "/subscriptions/a7b50fa6-5f5f-49b4-aa1c-128242d19284/resourceGroups/eus2-rg-kv/providers/Microsoft.KeyVault/vaults/eus2-kv-hsm-1"
                },
                "secretName": "ser-azurewvd"
            }
        },
        "adminPassword": {
            "reference": {
                "keyVault": {
                    "id": "/subscriptions/a7b50fa6-5f5f-49b4-aa1c-128242d19284/resourceGroups/eus2-rg-kv/providers/Microsoft.KeyVault/vaults/eus2-kv-hsm-1"
                },
                "secretName": "winteladm"
            }
        }
    }
}
```

## Clone AVD Deployment Files to create a new deployment

### This section describes how to copy existing deployment files so you can deploy a new host pool for a different group of users.

### Assumptions. 
```
1. Group name will change from "BO" to "Inf"
2. Type will still be "pooled" not "Personal"
3. location will not change from eastus2
4. Workspace will not change
5. log analytics will not change
```

### Files:
copy the 3 files, ensuring they stay in the corresponding folder of their copy.
rename the files changing BO to INF
```
1. azuredeploy.parameters.bo-hp.json
2. azuredeploy.parameters.bo-apps.json
3. azuredeploy.parameters.bo-sh.json
```
```
1. azuredeploy.parameters.inf-hp.json
2. azuredeploy.parameters.inf-apps.json
3. azuredeploy.parameters.inf-sh.json
```

### Existing Hostpool Parameter file azuredeploy.parameters.bo-hp.json
```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "hostpoolName": {
            "value": "eus2-avd-bo-hp"
        },
        "hostpoolFriendlyName": {
            "value": "Cantor AMER Back Office HostPool"
        },
        "hostpoolDescription": {
            "value": "Cantor AMER Back Office HostPool"
        },
        "location": {
            "value": "eastus2"
        },
        "hostpoolType": {
            "value": "Pooled"
        },
        "maxSessionLimit": {
            "value": 10
        },
        "loadBalancerType": {
            "value": "DepthFirst"
        },
        "validationEnvironment": {
            "value": false
        },
        "workspaceResourceId": {
            "value": "/subscriptions/a7b50fa6-5f5f-49b4-aa1c-128242d19284/resourceGroups/eus2-rg-avd-services/providers/Microsoft.DesktopVirtualization/workspaces/eus2-avd-ws-production"
        },
        "logAnalyticsWorkSpaceId": {
            "value": "/subscriptions/65248a74-84e8-46d6-b373-01a13b664a20/resourcegroups/loganalytics/providers/microsoft.operationalinsights/workspaces/bgcloganalytics"
        },
        "createDesktopAppGroup": {
            "value": false
        }
    }
}
```

### Changes to Hostpool Parameters file

Changes to:
```
1. hostpoolName
2. hostpoolFriendlyName
3. hostpoolDescription
```

```json
"hostpoolName": {
            "value": "eus2-avd-inf-hp"
        },
*****************************      
"hostpoolFriendlyName": {
            "value": "Cantor AMER Infrastructure HostPool"
        },
*****************************        
"hostpoolDescription": {
            "value": "Cantor AMER Infrastructure HostPool"
        },

```

### Existing ApplicationGroups Parameter file azuredeploy.parameters.bo-apps.json
```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "appGroupName": {
            "value": "AMER Back Office User Applications"
        },
        "location": {
            "value": "eastus2"
        },
        "appGroupType": {
            "value": "RemoteApp"
        },
        "hostpoolName": {
            "value": "eus2-avd-bo-hp"
        },
        "appGroupFriendlyName": {
            "value": "AMER Back Office User Applications"
        },
        "appGroupDescription": {
            "value": "AMER Back Office HostPool"
        },
        "workspaceResourceId": {
            "value": "/subscriptions/a7b50fa6-5f5f-49b4-aa1c-128242d19284/resourceGroups/eus2-rg-avd-services/providers/Microsoft.DesktopVirtualization/workspaces/eus2-avd-ws-production"
        },
        "logAnalyticsWorkSpaceId": {
            "value": "/subscriptions/65248a74-84e8-46d6-b373-01a13b664a20/resourcegroups/loganalytics/providers/microsoft.operationalinsights/workspaces/bgcloganalytics"
        }
    }
}

```

### Changes to ApplicationGroups Parameters file

Changes to:
```
1. appGroupName
2. hostpoolName
3. appGroupFriendlyName
4. appGroupDescription
```

```json
"appGroupName": {
            "value": "AMER Infrastructure User Applications"
        },
*****************************

"hostpoolName": {
            "value": "eus2-avd-inf-hp"
        },
*****************************
 "appGroupFriendlyName": {
            "value": "AMER Infrastructure User Applications"
        },
*****************************       
"appGroupDescription": {
            "value": "AMER Infrastructure HostPool"
        },
```

### Existing ApplicationGroups Parameter file azuredeploy.parameters.bo-apps.json
```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "hostpoolName": {
            "value": "eus2-avd-bo-hp"
        },
        "vmNamePrefix": {
            "value": "eus2avdbo"
        },
        "vmInitialNumber": {
            "value": 1
        },
        "rdshNumberOfInstances": {
            "value": 5
        },
        "rdshVmSize": {
            "value": "Standard_D2as_v4"
        },
        "rdshImageSource": {
            "value": "SharedImageGallery"
        },
        "SharedImageGalleryResourceGroup": {
            "value": "eus2-rg-sig"
        },
        "SharedImageGalleryName": {
            "value": "eus2sig01"
        },
        "SharedImageGalleryVersionName": {
            "value": "latest"
        },
        "SharedImageGalleryDefinitionName": {
            "value": "eus2sigwvd21h1v2"
        },
        "subnetResourceId": {
            "value": "/subscriptions/a7b50fa6-5f5f-49b4-aa1c-128242d19284/resourceGroups/eus2-rg-wvd/providers/Microsoft.Network/virtualNetworks/eus2-vn-wvd/subnets/eus2-vn-wvd-sn-1"
        },
        "domainToJoin": {
            "value": "cad.local"
        },
        "ouPath": {
            "value": "OU=eus2-avd-bo-hp,OU=Hostpools,OU=eus2,OU=Azure WVD,DC=cad,DC=local"
        },
        "domainJoinUsername": {
            "value": "ser-azurewvd"
        },
        "domainJoinPassword": {
            "reference": {
                "keyVault": {
                    "id": "/subscriptions/a7b50fa6-5f5f-49b4-aa1c-128242d19284/resourceGroups/eus2-rg-kv/providers/Microsoft.KeyVault/vaults/eus2-kv-hsm-1"
                },
                "secretName": "ser-azurewvd"
            }
        },
        "adminPassword": {
            "reference": {
                "keyVault": {
                    "id": "/subscriptions/a7b50fa6-5f5f-49b4-aa1c-128242d19284/resourceGroups/eus2-rg-kv/providers/Microsoft.KeyVault/vaults/eus2-kv-hsm-1"
                },
                "secretName": "winteladm"
            }
        }
    }
}

```

### Changes to ApplicationGroups Parameters file

Changes to:
```
1. hostpoolName
2. vmNamePrefix
3. ouPath
```

```json
"hostpoolName": {
            "value": "eus2-avd-inf-hp"
        },
***************************** 
        "vmNamePrefix": {
            "value": "eus2avdinf"
        },
*****************************       
  "ouPath": {
            "value": "OU=eus2-avd-inf-hp,OU=Hostpools,OU=eus2,OU=Azure WVD,DC=cad,DC=local"
        },        
```

### Optional changes Hostpool Parameter File
```
1. maxSessionLimit
    Change to the amount of users per host.
2. loadBalancerType
    DepthFirst will fill the host up with user, BreadthFirst will put users across all hosts.
```

```json
"maxSessionLimit": {
            "value": 10
        },
*****************************         
        "loadBalancerType": {
            "value": "DepthFirst"
        },
```

### Optional changes SessionHosts Parameter File
```
1. vmInitialNumber
    The numerical number of the session host that naming will start from. if you don't want to start at 1 change to example 17
2. rdshNumberOfInstances
    The number of session hosts that will be deployed.
3. rdshVmSize
    VM Size is location dependant.
    to get a list of VM sizes:
    Connect-azaccount
    Get-AzSubscription | sort-object name
    Select-AzSubscription bgc-amer-infrastructure-prod 
    get-azvmsize -Location eastus2 | Sort-Object name
4. SharedImageGalleryDefinitionName
    if using the same shared image gallery all should stay the same with the exception of this value as it will represent the template to be used.
```

```json
"vmInitialNumber": {
            "value": 17
        },
"rdshNumberOfInstances": {
            "value": 15
        },
"rdshVmSize": {
            "value": "Standard_DS14_v2"
        },
"rdshImageSource": {
            "value": "SharedImageGallery"
        },
"SharedImageGalleryResourceGroup": {
            "value": "eus2-rg-sig"
        },
"SharedImageGalleryName": {
            "value": "eus2sig01"
        },
"SharedImageGalleryVersionName": {
            "value": "latest"
        },
"SharedImageGalleryDefinitionName": {
            "value": "eus2sigwvd21h1v2"
        },
```


