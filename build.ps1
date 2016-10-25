Param(
    $ResourceGroupName,
    $ConfigurationName
)

function ConvertFrom-ConfigData
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Microsoft.PowerShell.DesiredStateConfiguration.ArgumentToConfigurationDataTransformation()]
        [hashtable] $data
    )
    return $data
}
get-location
get-item -path .
get-childitem -path .

write-output "resourcegroupname = $resourcegroupname"
write-output "configurationname = $ConfigurationName"
#write-output "sourceroot = $sourceroot"

$automationaccount = get-azurermautomationaccount -ResourceGroupName $ResourceGroupName
Import-AzureRmAutomationDscConfiguration -ResourceGroupName $ResourceGroupName -AutomationAccountName $automationaccount.AutomationAccountName  -SourcePath ".\$ConfigurationName.ps1" -Published
Start-AzureRmAutomationDscCompilationJob -ConfigurationName $ConfigurationName -ConfigurationData $(ConvertFrom-ConfigData ".\ConfigurationData.psd1") -ResourceGroupName $ResourceGroupName -AutomationAccountName $automationaccount.AutomationAccountName