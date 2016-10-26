#Pester tests to validate environment after ARM templates have been deployed.
param(
    $ResourceGroupName = 'ADTest',
    $SourceDir = $env:BUILD_SOURCESDIRECTORY
)

$ARMTemplateData = get-content "$SourceDir\AzureDeploy.json" | convertfrom-json
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