$SubscriptionID = 'f46c6948-bc45-4a1b-ba71-6934538ed594'
$Location = 'westcentralus'
$ResourceGroupName = 'ADTest'

Login-AzureRmAccount
Set-AzureRmContext -SubscriptionId $SubscriptionID
New-AzureRmResourceGroup -name $ResourceGroupName -Location $Location
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile C:\scripts\GITHubRepos\AzureRM-DSC-ADTest\AzureDeploy.json