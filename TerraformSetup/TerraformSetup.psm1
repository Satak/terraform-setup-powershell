function Get-TerraformVersion {
    <#
    .SYNOPSIS
        Get all Terraform versions
    .DESCRIPTION
        Get all Terraform versions from Github API
    .EXAMPLE
        Get-TerraformVersion
    .PARAMETER Latest
        Get only the latest release
    #>
    [CmdletBinding()]
    param (
        [switch]$Latest
    )
    $gitHubAPIURL = 'https://api.github.com/repos/hashicorp/terraform/releases'
    if ($Latest) {
        $gitHubAPIURL += '/latest'
    }
    (Invoke-RestMethod -Uri $gitHubAPIURL).tag_name.TrimStart('v')
}

function Install-Terraform {
    <#
    .SYNOPSIS
        Install Terraform for Windows
    .DESCRIPTION
        Automatically downloads Terraform binary agent and installs it for Windows x64 OS under System32
    .EXAMPLE
        Install-Terraform -TerraformVersion 'latest'
    .PARAMETER TerraformVersion
        Terraform version to be installed. If you don't specify this or set it to 'latest' module will get latest release from GitHub API
    .PARAMETER Force
        Force installation even you have previous terraform.exe installed
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [ValidatePattern('(^(\d+\.)?(\d+\.)?(\*|\d+)$)')]
        [string]$TerraformVersion,
        [switch]$Force
    )
    # get latest release from GitHub and download it if user don't provide the version
    if (!$TerraformVersion) {
        Write-Debug "Terraform version not set by user. Setting it to latest version found from GitHub API"
        $TerraformVersion = Get-TerraformVersion -Latest
        Write-Output "Latest Terraform version found from GitHub API: $TerraformVersion"
    }
    $tfInstallPath = Join-Path $env:SystemRoot 'System32'
    $tfExePath = Join-Path $tfInstallPath 'terraform.exe'
    $tfZipFileName = "terraform_$($TerraformVersion)_windows_amd64.zip"
    $tfZipFilePath = (Join-Path $tfInstallPath $tfZipFileName)
    $tfURL = "https://releases.hashicorp.com/terraform/$($TerraformVersion)/$tfZipFileName"

    if ((Test-Path $tfExePath) -and !$Force) {
        Write-Warning "Terraform is already installed to System32. Use -Force switch to bypass the check or manually remove terraform.exe. Version:"
        terraform -version
        break
    }

    if (!(Test-Path $tfZipFilePath) -or $Force) {
        try {
            # download terraform.zip from hashicorp.com
            Write-Debug "Downloading Terraform version $TerraformVersion from $tfURL"
            Invoke-WebRequest $tfURL -OutFile $tfZipFilePath -ErrorAction Stop 
        }
        catch {
            Write-Warning "$TerraformVersion is an invalid Terraform version. Please use one below:"
            Get-TerraformVersion
            break
        }
    }
    # unzip terraform.zip -> C:\Windows\System32\terraform.exe
    Expand-Archive -Path $tfZipFilePath -DestinationPath $tfInstallPath -Force

    # Remove terraform.zip
    Remove-Item $tfZipFilePath -ErrorAction SilentlyContinue

    Write-Output "Terraform successfully installed. Version:"
    # test terraform
    terraform -version
}

function New-TerraformFolders {
    <#
    .SYNOPSIS
        Create Terraform module and template folders
    .DESCRIPTION
        Create a folder structure for all your Terraform modules and templates
    .EXAMPLE
        Install-Terraform -TerraformWorkPath 'C:\Terraform'
    .PARAMETER TerraformWorkPath
        Root path for your Terraform modules and templates. Default: C:\Terraform
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$TerraformWorkPath = 'C:\Terraform'
    )
    $tfTemplateRootPath = Join-Path $TerraformWorkPath 'templates'
    $tfWindowsTemplatePath = Join-Path $tfTemplateRootPath 'windows'
    $tfLinuxTemplatePath = Join-Path $tfTemplateRootPath 'linux'
    $tfModulePath = Join-Path $TerraformWorkPath 'modules'

    # create terraform module and template folders under C:\Terraform
    $tfWindowsTemplatePath, $tfLinuxTemplatePath, $tfModulePath | ForEach-Object { New-Item $_ -ItemType Directory -ErrorAction SilentlyContinue }
}
