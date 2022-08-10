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
$MenuItem = "Run", "Edit", "View", "Delete" # example menu item list

#endregion


################################################################################
#region #*      Logging Initialization
################################################################################

$LogFolder = "logs"
if ( -not ( Test-Path $LogFolder ) ) {
    New-Item $FolderName -ItemType Directory
    Write-Host "Created logging folder in local directory"
}

Start-Transcript -Append "$LogFolder\$(Get-Date -f yyyy-MM-dd)_$$Verb-$$Noun.txt"

#endregion


################################################################################
#region #*      Imports & Dependency Handling
################################################################################

If ( -not ( Get-Module -ListAvailable -Name ModuleName ) ) {
  Install-Module ModuleName
  Import-Module ModuleName
}
#endregion


################################################################################
#region #*      Config File Handling
################################################################################

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

#endregion


################################################################################
#region #*      User Menu (if needed)
################################################################################
function Show-Menu {
  param (
    [string]$Title = 'My Menu',
    [string[]]$MenuItems
  )

  Clear-Host
  Write-Host "============================================================"
  Write-Host $MenuTitle
  Write-Host "============================================================"
  
  ForEach ( $MenuItem in $MenuItems ) {
    Write-Host $array.IndexOf($item) + ": " + $MenuItem
  }
  Write-Host "Q. Quit"
  
  Write-Host "============================================================"
}

#endregion


################################################################################
#region #*      Supporting Functions
################################################################################

#endregion


################################################################################
#region #*      Main Program Loop
################################################################################

function Verb-Noun {
  [CmdletBinding()]
  param (
    
  )
  
  # Load Config File
  Get-Config -ConfigFilePath "config.conf"

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
}

#endregion

# Stop Logging
Stop-Transcript

# Dev References (not user references, which should be included in .LINKs at top)