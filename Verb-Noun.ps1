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

################################################################################
#region #*      User-definable Variables
################################################################################
#? The following variables can be modified by the user.
$ConfigFilePath = "config.conf" # default config file path
$LogFolderPath = "logs"
#endregion


################################################################################
#region #*      Global Variables
################################################################################

$Menu = [ordered]@{
  "Header1" = "Run", "Edit", "View", "Delete"; # example menu item list
  "Header2" = "Create", "Read", "Update", "Delete"; # example menu item list
}

#endregion


################################################################################
#region #*      Logging Initialization
################################################################################


if ( -not ( Test-Path $LogFolderPath ) ) {
    New-Item $LogFolderPath -ItemType Directory
    Write-Host "Created logging folder in local directory"
}

#! Modify to match module name
Start-Transcript -Append "$LogFolderPath\$(Get-Date -f yyyy-MM-dd)_Verb-Noun.txt"

#endregion


################################################################################
#region #*      Imports & Dependency Handling
################################################################################

#! Modify to include any dependencies
# If ( -not ( Get-Module -ListAvailable -Name ModuleName ) ) {
#   Install-Module ModuleName
#   Import-Module ModuleName
# }
#endregion


################################################################################
#region #*      Config File Handling
################################################################################

function Get-Config {
  param (
    [string]$ConfigFilePath
  )
  # Get-Content $ConfigFilePath | ForEach-Object -Begin { $Config=@{} } -process { 
  #   $Key = [regex]::split($_,'='); If( ( $Key[0].CompareTo("") -ne 0 ) -and ( $Key[0].StartsWith("[") -ne $True ) ) { 
  #     $Config.Add($Key[0], $Key[1])
  #   }
  # }

  $Config = Get-Content -Path $ConfigFilePath | ConvertFrom-Json

  return $Config
}

#endregion


################################################################################
#region #*      Supporting Functions
################################################################################
function Verb-Noun {
  [CmdletBinding()]
  param (
    
  )
  
}
#endregion


################################################################################
#region #*      User Menu (if needed)
################################################################################
function Show-Menu {
  param (
    [string]$MenuTitle = 'My Menu',
    $Menu
  )

  $CenteredTitle = ("| $(" " * ( ( 55 - $MenuTitle.Length ) / 2 ) ) $MenuTitle $( " " * ( ( 55 - $MenuTitle.Length ) / 2 ) )").substring(0, 59)+"|"

  Clear-Host
  Write-Host "|============================================================|"
  Write-Host $CenteredTitle
  Write-Host "|============================================================|"
  
  $MenuIndex = 0
  ForEach ( $MenuSection in $Menu.Keys ) {
    Write-Host ("|$(" " * ( ( 56 - $MenuSection.Length ) / 2)) $MenuSection $(" " * ( ( 56 - $MenuSection.Length ) / 2))").substring(0, 58)"|"
    
    ForEach ( $MenuItem in $Menu[$MenuSection] ) {
      $MenuIndex++
      Write-Host ("| $MenuIndex. $MenuItem").PadRight(58," ")"|"
    }
    
    Write-Host "|                                                           |"
  }

  
  Write-Host "============================================================"
}

#endregion


################################################################################
#region #*      Main Program Loop
################################################################################

$Config = Get-Config -ConfigFilePath $ConfigFilePath


do {
  Show-Menu -MenuItems $MenuItems
  $selection = (Read-Host "Select an option: ").toLower()
  switch ($selection)
  {
    '1' {
      # do thing here (eg assign var, call function, etc)
      'You chose option #1'
    } '2' {
      # do thing here (eg assign var, call function, etc)
      'You chose option #2'
    } '3' {
      # do thing here (eg assign var, call function, etc)
      'You chose option #3'
    }
  }
  pause
}
until ($selection -eq 'q')


#endregion

# Stop Logging
Stop-Transcript

# Dev References (not user references, which should be included in .LINKs at top)