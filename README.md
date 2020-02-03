# Terraform Install and Setup module for Powershell

![Publish](https://github.com/Satak/terraform-setup-powershell/workflows/Publish/badge.svg?branch=master)

Automate your Windows Terraform installation process.

## Usage

```powershell
Import-Module 'TerraformSetup'

# Specify TerraformVersion or just run 'Install-Terraform' to install the latest version of Terraform. Use -Force to override the current Terraform version.
Install-Terraform -TerraformVersion '0.12.20'

# Create work folder structure under C:\Terraform
New-TerraformFolders

# [OPTIONAL] to get all Terraform versions run
Get-TerraformVersion

# Uninstall terraform
Uninstall-Terraform
```

## Powershell Gallery

This module is automatically published to Powershell gallery via GitHub actions from GitHub Release:

<https://www.powershellgallery.com/packages/TerraformSetup>
