#Pester tests to validate environment after ARM templates have been deployed.
param(
    $ResourceGroupName = 'ADTest',
    $SourceDir = $env:BUILD_SOURCESDIRECTORY
)

$ARMTemplateData = get-content "$SourceDir\AzureDeploy.json" | convertfrom-json
$ResourceGroup = Get-AzureRmResourceGroup -Name $ResourceGroupName
$StorageAccount = Get-AzureRmStorageAccount

Describe 'ARM Template validation tests'{
    It 'verifies virtual machine creation'{
        $(Get-azurermVM -ResourceGroupName $ResourceGroupName).Count -eq $($ARMTemplateData.Resources.where{$_.Type -eq 'Microsoft.Compute/virtualMachines'}).count | should be $true
    }
}