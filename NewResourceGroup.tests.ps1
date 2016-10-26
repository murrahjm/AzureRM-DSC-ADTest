#pester test to validate resource group exists before continuing to next build step
Param($ResourceGroupname='ADTest')

Describe "Resource Group Test"{
    It 'verifies Resourcegroup creation'{
        $ResourceGroup = get-AzureRMResourceGroup -Name $ResourceGroupname -ea Stop
        $ResourceGroup.ResourceGroupName | should be $ResourceGroupName             
        $ResourceGroup.ProvisioningState | should be 'Succeeded'
    }
}