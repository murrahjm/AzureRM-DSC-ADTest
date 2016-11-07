#First build step, creates resource group if it doesn't already exist.  Populates variables for ARM template deployment
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

$AZureAutomationAccountName = "AzureAutomation-$env:ResourceGroupName"
$ErrorActionPreference = 'Stop'

If (!(Get-AzureRmResourceGroup $env:ResourceGroupName -ea 'SilentlyContinue')){
    New-AzureRmResourceGroup -name $env:ResourceGroupName -location $env:location
}
If (!(Get-AzureRMAutomationAccount -ResourceGroupName $env:ResourceGroupName -ea 'SilentlyContinue')){
    New-AzureRMAutomationAccount -ResourceGroupName $env:ResourceGroupName -name $AZureAutomationAccountName -Location $env:location -Plan Free
}
$DSCRegInfo = Get-AzureRmAutomationRegistrationInfo -ResourceGroupName $env:ResourceGroupName -AutomationAccountName $AZureAutomationAccountName
$Configdata = $(ConvertFrom-ConfigData "$env:BUILD_SOURCESDIRECTORY\configurationdata.psd1" | convertto-json -Depth 20 -Compress).ToString()
$TimeStamp = $(get-date -uformat "%D %r").ToString()

write-host "##vso[task.setvariable variable=DSCRegistrationKey;]$(DSCRegInfo.PrimaryKey)"
write-host "##vso[task.setvariable variable=DSCRegistrationURL;]$(DSCRegInfo.EndPoint)"
write-host "##vso[task.setvariable variable=jobID;]$([System.Guid]::NewGuid().toString())"
write-host "##vso[task.setvariable variable=ConfigData;]$Configdata"
write-host "##vso[task.setvariable variable=timestamp;]$TimeStamp"

