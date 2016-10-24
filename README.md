# AzureRM-DSC-ADTest
Training sample for configuring an AD lab with Azure resource manager templates and Azure Automation DSC configurations to deploy entire environment with a visual studio team services build script.

Goal is to perform this training/lab with everything in the cloud as much as possible.  Working files will stay in github, builds done with visual studio team services account.

File list will probably be something like this:

--AzureDeploy.json - Azure resource manager template to deploy 4 VMs on 3 different subnets

--ActiveDirectoryDSCConfig.ps1 - DSC Configuration document to install ADDS on 3 servers and create an active directory domain

--ADTestLab.tests.ps1 - pester tests to validate environment after creation

Probably some other files as well, still not sure about the build script or azure automation/dsc pull server setup.
