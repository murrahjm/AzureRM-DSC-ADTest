# PSake makes variables declared here available in other scriptblocks
# Init some things
Properties {
    # Find the build folder based on build system
    if(-not $env:ProjectRoot){$env:ProjectRoot = $PSScriptRoot}
    $Timestamp = Get-date -uformat "%Y%m%d-%H%M%S"
    $PSVersion = $PSVersionTable.PSVersion.Major
    $TestFile = "TestResults_PS$PSVersion`_$TimeStamp.xml"
    $lines = '----------------------------------------------------------------------'
    $ErrorActionPreference = 'Stop'
    $AzureAutomationAccountName = "AzureAutomation-$env:ResourceGroupName"
    If ($env:BuildSystem -eq 'AppVeyor'){
        $SecureAdminPassword = $env:AdminPassword | convertto-securestring -AsPlainText -Force
    } elseif ($env:BuildSystem -eq 'Manual'){
            $SecureAdminPassword = $env:AdminPassword | convertto-SecureString
    }
}

Task Default -Depends BuildAzureEnvironment

Task Init {
    $lines
    #azure login code goes here for appveyor build system
    if ($env:BuildSystem -eq 'AppVeyor'){
        Disable-AzureRmDataCollection
        $AzureCredential = new-object -TypeName pscredential -ArgumentList $env:azureapploginid, $($env:azurepassword | convertto-securestring -AsPlainText -force)
        Login-AzureRmAccount -Credential $AzureCredential -ServicePrincipal -TenantId $env:AzureTenantID -ErrorAction Stop | out-null
    }
    #
}
Task BuildAzureResourceGroup -Depends Init {
    #create new azure resource group if it doesn't already exist
If (!(Get-AzureRmResourceGroup $env:ResourceGroupName -ea 'SilentlyContinue')){
    New-AzureRmResourceGroup -name $env:ResourceGroupName -location $env:location
}
If (!(Get-AzureRMAutomationAccount -ResourceGroupName $env:ResourceGroupName -ea 'SilentlyContinue')){
    New-AzureRMAutomationAccount -ResourceGroupName $env:ResourceGroupName -name $AZureAutomationAccountName -Location $env:location -Plan Free
}
$script:DSCRegInfo = Get-AzureRmAutomationRegistrationInfo -ResourceGroupName $env:ResourceGroupName -AutomationAccountName $AZureAutomationAccountName

}
Task TestAzureResourceGroup -Depends BuildAzureResourceGroup {
    #verify resource group creation
    $lines
    # Gather test results. Store them in a variable and file
    $TestResults = Invoke-Pester -Path "$env:ProjectRoot\NewResourceGroup.tests.ps1" -PassThru -OutputFormat NUnitXml -OutputFile "$env:ProjectRoot\$TestFile"

    # In Appveyor?  Upload our tests! #Abstract this into a function?
    If($env:BuildSystem -eq 'AppVeyor')
    {
        (New-Object 'System.Net.WebClient').UploadFile(
            "https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)",
            "$env:ProjectRoot\$TestFile" )
    }

    Remove-Item "$env:ProjectRoot\$TestFile" -Force -ErrorAction SilentlyContinue

    # Failed tests?
    # Need to tell psake or it will proceed to the deployment. Danger!
    if($TestResults.FailedCount -gt 0)
    {
        Write-Error "Failed '$($TestResults.FailedCount)' tests, build failed"
    }
    "`n"
}
Task BuildAzureEnvironment -Depends TestAzureResourceGroup {
    write-output "Building Azure deployment with the following variables:"
    $DeploymentParams = @{}
    $DeploymentParams.jobConfigurationData = (import-powershelldatafile "$env:ProjectRoot\ConfigurationData.psd1" | convertto-json -Depth 20 -Compress).ToString()
    $DeploymentParams.ResourceGroupName = $env:ResourceGroupName
    $DeploymentParams.TemplateFile = "$env:ProjectRoot\AzureDeploy.json"
    $DeploymentParams.TemplateParameterFile = "$env:ProjectRoot\AzureDeploy.parameters.json"
    $DeploymentParams.registrationKey = $script:DSCReginfo.PrimaryKey
    $DeploymentParams.registrationURL = $script:DSCReginfo.Endpoint
    $DeploymentParams.virtualMachines_adminPassword = $SecureAdminPassword
    $DeploymentParams.JobID = (new-guid).guid
    $DeploymentParams.Timestamp = $(get-date -uformat "%D %r").ToString()
    write-output $DeploymentParams

    $TestResult = test-AzureRmResourceGroupDeployment @DeploymentParams

    If ($Testresult.count -eq 0){
        $Result = New-AzureRmResourceGroupDeployment @DeploymentParams
        If ($result.ProvisioningState -ne 'Succeeded'){
            write-error $Result
            return
        }
    } else {
        write-error $TestResult.message
        return
    }

}
