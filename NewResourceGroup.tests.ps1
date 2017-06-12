#pester test to validate resource group exists before continuing to next build step
Describe "Resource Group Test"{
    It 'verifies Resourcegroup creation'{
        $ResourceGroup = get-AzureRMResourceGroup -Name $env:ResourceGroupname -ea Stop
        $ResourceGroup.ResourceGroupName | should be $env:ResourceGroupName             
        $ResourceGroup.ProvisioningState | should be 'Succeeded'
    }
    It 'verifies azure automation account creation' {
        $AA = Get-AzureRmAutomationAccount -ResourceGroupName $env:ResourceGroupname -Name "AzureAutomation-$env:ResourceGroupname" -ea Stop
        
        
    }
    It 'verifies DSC configuration info' {
        $DSCInfo = Get-AzureRmAutomationRegistrationInfo -ResourceGroupName $env:resourceGroupName -AutomationAccountName "AzureAutomation-$env:resourceGroupName" -ea Stop
        $DSCInfo.PrimaryKey | should not benullorempty
        $DSCInfo.Endpoint | should not benullorempty
    }
}