#Pester tests to validate environment after ARM templates have been deployed.
param($ResourceGroupName,$SourcePath)

$ARMTemplateData = get-content "$SourcePath\AzureDeploy.json" | convertfrom-json
$ResourceGroup = Get-AzureRmResourceGroup -Name $ResourceGroupName
$StorageAccount = Get-AzureRmStorageAccount

Describe 'ARM Template validation tests'{
    It 'verifies Resourcegroup creation'{
        $ResourceGroup.ResourceGroupName | should be $ResourceGroupName             
        $ResourceGroup.ProvisioningState | should be 'Succeeded'
    }
    It 'verifies virtual machine creation'{
        $(Get-azurermvirtualmachine).Count -eq $($ARMTemplateData.Resources.where{$_.Type -eq 'Microsoft.Compute/virtualMachines'}).count | should be $true
    }
}