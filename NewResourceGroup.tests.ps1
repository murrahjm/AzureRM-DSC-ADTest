#pester test to validate resource group exists before continuing to next build step
Param($ResourceGroupname)
    Import-Module "Microsoft.TeamFoundation.DistributedTask.Task.Internal"

Describe "Resource Group Test"{
    It 'verifies Resourcegroup creation'{
        $ResourceGroup = get-AzureRMResourceGroup -Name $ResourceGroupname -ea Stop
        $ResourceGroup.ResourceGroupName | should be $ResourceGroupName             
        $ResourceGroup.ProvisioningState | should be 'Succeeded'
    }
    It 'verifies azure automation account creation'
        $AA = Get-AzureRmAutomationAccount -ResourceGroupName $ResourceGroupname -Name "AzureAutomation-$ResourceGroupname" -ea Stop
        $AA | should not benullorempty
    }
    It 'verifies TFS variables set with DSC info' {
        Get-TaskVariable $distributedTaskContext "DSCRegistrationKey" | should not benullorempty
        Get-TaskVariable $distributedTaskContext "DSCRegistrationURL" | should not benullorempty
    }
