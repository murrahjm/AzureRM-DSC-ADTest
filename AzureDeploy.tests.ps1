#Pester tests to validate environment after ARM templates have been deployed.
param(
    $SourceDir = $env:BUILD_SOURCESDIRECTORY
)

Describe 'ARM Template validation tests'{
$ARMTemplateData = get-content "$SourceDir\AzureDeploy.json" | convertfrom-json
$ResourceGroup = Get-AzureRmResourceGroup -Name $ResourceGroupName
$StorageAccount = Get-AzureRmStorageAccount

    It 'verifies virtual machine creation'{
        $(Get-azurermVM -ResourceGroupName $ResourceGroupName).Count -eq $($ARMTemplateData.Resources.where{$_.Type -eq 'Microsoft.Compute/virtualMachines'}).count | should be $true
    }
}