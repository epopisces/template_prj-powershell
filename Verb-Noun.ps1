<#
.SYNOPSIS
A brief description of the function or script. This keyword can be used only once in each topic.

.DESCRIPTION
A detailed description of the function or script. This keyword can be used only once in each topic.

.PARAMETER <parameter>
The description of a parameter. Add a .PARAMETER keyword for each parameter in the function or script syntax.

.EXAMPLE
A sample command that uses the function or script, optionally followed by sample output and a description. Repeat this keyword for each example.

.INPUTS
The .NET types of objects that can be piped to the function or script. You can also include a description of the input objects.

.OUTPUTS
The .NET type of the objects that the cmdlet returns. You can also include a description of the returned objects.

.NOTES
Additional information about the function or script.

.LINK
The name of a related topic. The value appears on the line below the ".LINK" keyword and must be preceded by a comment symbol # or included in the comment block.

Repeat the .LINK keyword for each related topic.
#>

# Logging
$LogFolder = "logs"
if ( -not ( Test-Path $LogFolder ) ) {
    New-Item $FolderName -ItemType Directory
    Write-Host "Created logging folder in local directory"
}

Start-Transcript -Append "$LogFolder\$(Get-Date -f yyyy-MM-dd)_$$Verb-$$Noun.txt"

# Imports & Dependency Handling
If ( -not ( Get-Module -ListAvailable -Name ModuleName ) ) {
  Install-Module ModuleName
  Import-Module ModuleName
}

# Config File Handling
function Get-Config {
  param (
    [string]$ConfigFilePath
  )
  Get-Content $ConfigFilePath | ForEach-Object -Begin { $Config=@{} } -process { 
    $Key = [regex]::split($_,'='); If( ( $Key[0].CompareTo("") -ne 0 ) -and ( $Key[0].StartsWith("[") -ne $True ) ) { 
      $Config.Add($Key[0], $Key[1])
    }
  }
}

# User Menu (if needed)
function Show-Menu {
  param (
    [string]$Title = 'My Menu'
    [string[]]$MenuItems
  )
  Clear-Host
  Write-Host "============================================================"
  Write-Host $MenuTitle
  Write-Host "============================================================"
  
  ForEach ( $MenuItem in $MenuItems ) {
    Write-Host $array.IndexOf($item) + ": " + $MenuItem
  }
  
  Write-Host "============================================================"

  $MenuItem = Read-Host "Select an option: "
  Return $MenuItem
}
# Sundry Functions

# Main Function
function Verb-Noun {
  [CmdletBinding()]
  param (
    
  )

  do {
    Show-Menu
    $selection = Read-Host "Please make a selection"
    switch ($selection)
    {
      '1' {
        'You chose option #1'
      } '2' {
        'You chose option #2'
      } '3' {
        'You chose option #3'
      }
    }
    pause
  }
  until ($selection -eq 'q')
}
# Stop Logging
Stop-Transcript

# Dev References )not user references, which should be included in .LINKs at top)