Param(
    $ResourceGroupName,
    $ConfigurationName,
    $SourcePath
)

$automationaccount = get-azurermautomationaccount -ResourceGroupName $ResourceGroupName
Import-AzureRmAutomationDscConfiguration -ResourceGroupName $ResourceGroupName -AutomationAccountName $automationaccount.AutomationAccountName  -SourcePath "$SourcePath$ConfigurationName.ps1" -Published
Start-AzureRmAutomationDscCompilationJob -ConfigurationName $ConfigurationName -ConfigurationData $(ConvertFrom-ConfigData "$SourcePath`ConfigurationData.psd1") -ResourceGroupName $ResourceGroupName -AutomationAccountName $automationaccount.AutomationAccountName