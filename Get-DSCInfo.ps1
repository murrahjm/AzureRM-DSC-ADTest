#Script to retrieve Azure automation DSC registrationkey, registrationURL and nodeConfigurationNames from existing azure automation account and output them into build environment variables
#method from URL http://blog.majcica.com/2016/02/19/passing-values-between-tfs-2015-build-steps/
Param($ResourceGroupName)

$AZureAutomationAccountName = $(Get-AzureRmAutomationAccount -ResourceGroupName $ResourceGroupName).AutomationAccountName
Import-Module "Microsoft.TeamFoundation.DistributedTask.Task.Common"
$DSCRegInfo = Get-AzureRmAutomationRegistrationInfo -ResourceGroupName $ResourceGroupName -AutomationAccountName $AZureAutomationAccountName

Set-TaskVariable "DSCRegistrationKey" $($DSCRegInfo.PrimaryKey)
Set-TaskVariable "DSCRegistrationURL" $($DSCRegInfo.Endpoint)
Set-TaskVariable "DSCConfigurationName"