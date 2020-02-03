$manifest = @{
    Path                  = '.\TerraformSetup\TerraformSetup.psd1'
    RootModule            = 'TerraformSetup.psm1' 
    Author                = 'Satak'
    CompanyName           = 'Fujitsu'
    Description           = 'Setup and install Terraform for Windows'
    ProcessorArchitecture = 'Amd64'
    PowerShellVersion     = '3.0'
    LicenseUri            = 'https://github.com/Satak/terraform-setup-powershell/blob/master/LICENSE'
    ProjectUri            = 'https://github.com/Satak/terraform-setup-powershell'
}

New-ModuleManifest @manifest
