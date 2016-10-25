Param(
    $ResourceGroupName,
    $ConfigurationName,
    $SourcePath
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

$automationaccount = get-azurermautomationaccount -ResourceGroupName $ResourceGroupName
Import-AzureRmAutomationDscConfiguration -ResourceGroupName $ResourceGroupName -AutomationAccountName $automationaccount.AutomationAccountName  -SourcePath "$SourcePath\$ConfigurationName.ps1" -Published -Force -verbose
Start-AzureRmAutomationDscCompilationJob -ConfigurationName $ConfigurationName -ConfigurationData $(ConvertFrom-ConfigData "$SourcePath\ConfigurationData.psd1") -ResourceGroupName $ResourceGroupName -AutomationAccountName $automationaccount.AutomationAccountName -verbose