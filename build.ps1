Param(
    $ResourceGroupName,
    $ConfigurationName,
    $SourceRoot
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

get-item
get-childitem
pwd
write-output "resourcegroupname = $resourcegroupname"
write-output "configurationname = $ConfigurationName"
write-output "sourceroot = $sourceroot"

$automationaccount = get-azurermautomationaccount -ResourceGroupName $ResourceGroupName
Import-AzureRmAutomationDscConfiguration -ResourceGroupName $ResourceGroupName -AutomationAccountName $automationaccount.AutomationAccountName  -SourcePath "$SourceRoot$ConfigurationName.ps1" -Published
Start-AzureRmAutomationDscCompilationJob -ConfigurationName $ConfigurationName -ConfigurationData $(ConvertFrom-ConfigData "$SourceRoot`ConfigurationData.psd1") -ResourceGroupName $ResourceGroupName -AutomationAccountName $automationaccount.AutomationAccountName