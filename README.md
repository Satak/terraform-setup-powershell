# Terraform Install and Setup module for Powershell

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
```
