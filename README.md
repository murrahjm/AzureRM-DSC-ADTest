### Current Build Status:
[![Build status](https://ci.appveyor.com/api/projects/status/6asgmul1u1b3libh/branch/master?svg=true)](https://ci.appveyor.com/project/murrahjm/azurerm-dsc-adtest/branch/master)

# AzureRM-DSC-ADTest
Training sample for configuring an AD lab with Azure resource manager templates and Azure Automation DSC configurations to deploy entire environment with an Appveyor build script.

Goal is to perform this training/lab with everything in the cloud as much as possible.  Working files will stay in github, builds done with Appveyor.

File list:

--AzureDeploy.json - Azure resource manager template to deploy 4 VMs on 3 different subnets

--ActiveDirectoryDSCConfig.ps1 - DSC Configuration document to install ADDS on 3 servers and create an active directory domain

--ADTestLab.tests.ps1 - pester tests to validate environment after creation

Probably some other files as well, still not sure about the build script or azure automation/dsc pull server setup.
