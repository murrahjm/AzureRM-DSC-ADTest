#script to launch pester and run tests.  this will be run by the VSTS build server.  eventually will be replaced by a Psake build script.

param($ScriptPath)

invoke-pester -script "$Scriptpath\AzureDeploy.tests.ps1"