
Connect-AzAccount

$context = Get-AzContext -ListAvailable | Out-GridView -Title 'Choose the Correct Azure Context' -PassThru
$context | Select-AzContext

$Subscription = Get-AzSubscription | Out-GridView -Title 'Choose the Correct Azure Subscription' -PassThru
$Subscription | Select-AzSubscription

#Get-AzContext
