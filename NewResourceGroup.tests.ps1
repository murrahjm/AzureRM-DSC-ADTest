#pester test to validate resource group exists before continuing to next build step

Describe "Resource Group Test"{
    It 'verifies Resourcegroup creation'{
        $ResourceGroup = get-AzureRMResourceGroup -Name $env:ResourceGroupname -ea Stop
        $ResourceGroup.ResourceGroupName | should be $env:ResourceGroupName             
        $ResourceGroup.ProvisioningState | should be 'Succeeded'
    }
    It 'verifies azure automation account creation' {
        $AA = Get-AzureRmAutomationAccount -ResourceGroupName $env:ResourceGroupname -Name "AzureAutomation-$env:ResourceGroupname" -ea Stop
        $AA | should not benullorempty
    }
    It 'verifies TFS variables set with DSC info' {
        $env:DSCRegistrationKey | should not benullorempty
        $env:DSCRegistrationURL | should not benullorempty
    }
}