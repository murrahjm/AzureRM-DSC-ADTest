#First build step, creates resource group if it doesn't already exist

Param($ResourceGroupName, $location)

If (!(Get-AzureRmResourceGroup $ResourceGroupName -ea 'SilentlyContinue')){
    New-AzureRmResourceGroup -name $ResourceGroupName -location $location
}
If (!(Get-AzureRMAutomationAccount -ResourceGroupName $ResourceGroupName -ea 'SilentlyContinue')){
    New-AzureRMAutomationAccount -name "AzureAutomation-$ResourceGroupName" -Location $location -Plan Free
}

