#build script to act as launcher for psake.ps1 in the case of a manual build (like for testing)
#appveyor builds will use appveyor.ps1, other build systems can use their own shim script
#sets the variables that psake.ps1 expects, check for dependant modules, then launches psake.ps1

$env:BuildSystem = 'Manual'
$env:ProjectRoot = $PSScriptRoot
$env:ResourceGroupName = 'ADTest'
$env:Location ='SouthCentralUS'
$DependentModules = @('AzureRM','Pester','Psake')
$env:AdminPassword = $(read-host "AdminPassword" -AsSecureString | convertFrom-SecureString)
$ErrorActionPreference = 'Stop'
Foreach ($Module in $DependentModules){
    If (-not (get-module $module -ListAvailable)){
        install-module -name $Module -Scope CurrentUser
    }
    import-module $module -ErrorAction Stop
}
Try {
    if (! (Get-AzureRmSubscription -SubscriptionName 'MSDN Platforms')){throw}
} catch {
     Login-AzureRMAccount -SubscriptionName 'MSDN Platforms'
}
invoke-psake "$PSScriptRoot\psake.ps1"
