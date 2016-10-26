#First build step, creates resource group if it doesn't already exist

Param($ResourceGroupName)

If (!(Get-AzureRmResourceGroup $ResourceGroupName -ea 'SilentlyContinue')){
    New-AzureRmResourceGroup $ResourceGroupName
}