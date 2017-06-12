#script to wedge in between appveyor.yml and psake.ps1
#basically sets all the variables that psake.ps1 expects, checks for dependant modules, then runs psake.ps1
#other build systems can have their own shim script.

$env:BuildSystem = 'Appveyor'
$env:ProjectRoot = $env:APPVEYOR_BUILD_FOLDER
Install-PackageProvider -Name NuGet -RequiredVersion 2.8.5.201 -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
$DependentModules = @('AzureRM','Pester','Psake')
Foreach ($Module in $DependentModules){
    If (-not (get-module $module -ListAvailable)){
        install-module -name $Module -Scope CurrentUser -allowClobber
    }
    import-module $module -ErrorAction Stop -allowClobber
}
invoke-psake "$env:ProjectRoot\psake.ps1"
