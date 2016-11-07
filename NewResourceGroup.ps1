#First build step, creates resource group if it doesn't already exist
gci env:
write-host $env:ResourceGroupName
$AZureAutomationAccountName = "AzureAutomation-$env:ResourceGroupName"
$ErrorActionPreference = 'Stop'

If (!(Get-AzureRmResourceGroup $env:ResourceGroupName -ea 'SilentlyContinue')){
    New-AzureRmResourceGroup -name $env:ResourceGroupName -location $env:location
}
If (!(Get-AzureRMAutomationAccount -ResourceGroupName $env:ResourceGroupName -ea 'SilentlyContinue')){
    New-AzureRMAutomationAccount -name $AZureAutomationAccountName -Location $$env:location -Plan Free
}
$DSCRegInfo = Get-AzureRmAutomationRegistrationInfo -ResourceGroupName $env:ResourceGroupName -AutomationAccountName $AZureAutomationAccountName

$env:DSCRegistrationKey = $($DSCRegInfo.PrimaryKey)
$env:DSCRegistrationURL = $($DSCRegInfo.Endpoint)

