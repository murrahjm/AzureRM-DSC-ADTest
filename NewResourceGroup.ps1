#First build step, creates resource group if it doesn't already exist

Param($ResourceGroupName, $location)

If (!(Get-AzureRmResourceGroup $ResourceGroupName -ea 'SilentlyContinue')){
    New-AzureRmResourceGroup -name $ResourceGroupName -location $location
}

