### Current Build Status:
[![Build status](https://ci.appveyor.com/api/projects/status/6asgmul1u1b3libh/branch/master?svg=true)](https://ci.appveyor.com/project/murrahjm/azurerm-dsc-adtest/branch/master)

# AzureRM-DSC-ADTest
Training sample for configuring an AD lab with Azure resource manager templates and Azure Automation DSC configurations to deploy entire environment with an Appveyor build script.

Goal is to perform this training/lab with everything in the cloud as much as possible.  Working files will stay in github, builds done with Appveyor.

File list:

--appveyor.yml & appveyor.ps1 - build scripts used by Appveyor build system to gather data and launch psake build script

--build.ps1 - build script for manual build system to gather data and launch psake build script

--psake.ps1 - psake script to perform build, testing and validation of lab environment

--AzureDeploy.json & AzureDeploy.parameters.json - Azure resource manager template to deploy 4 VMs on 3 different subnets

--ADTestConfiguration.ps1 - DSC Configuration document to install ADDS on 3 servers and create an active directory domain

--ConfigurationData.psd1 - Powershell data file listing machine specifics and ad forest configuration info.  Used by DSC configuration to create customized MOFs for each machine.

--ADTestLab.tests.ps1 - pester tests to validate environment after creation
