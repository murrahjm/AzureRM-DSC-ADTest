#First build step, creates resource group if it doesn't already exist

$AZureAutomationAccountName = "AzureAutomation-$env:ResourceGroupName"
$ErrorActionPreference = 'Stop'
Import-Module "Microsoft.TeamFoundation.DistributedTask.Task.Common"

If (!(Get-AzureRmResourceGroup $env:ResourceGroupName -ea 'SilentlyContinue')){
    New-AzureRmResourceGroup -name $env:ResourceGroupName -location $env:location
}
If (!(Get-AzureRMAutomationAccount -ResourceGroupName $env:ResourceGroupName -ea 'SilentlyContinue')){
    New-AzureRMAutomationAccount -name $AZureAutomationAccountName -Location $location -Plan Free
}
$DSCRegInfo = Get-AzureRmAutomationRegistrationInfo -ResourceGroupName $env:ResourceGroupName -AutomationAccountName $env:AZureAutomationAccountName

Set-TaskVariable "DSCRegistrationKey" $($DSCRegInfo.PrimaryKey)
Set-TaskVariable "DSCRegistrationURL" $($DSCRegInfo.Endpoint)

