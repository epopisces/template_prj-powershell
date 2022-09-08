<#
.SYNOPSIS
A PowerShell script that... (brief description of the function or script. This keyword can be used only once in each topic.)

.DESCRIPTION
This script will...(detailed description of the function or script. This keyword can be used only once in each topic.)

.PARAMETER <parameter>
The description of a parameter. Add a .PARAMETER keyword for each parameter in the function or script syntax.

.PARAMETER configFilePath
The path to the config file that contains the settings for the script.  Defaults to a file named config.conf in the same directory as the script.

.PARAMETER debug
A boolean value that determines if the script should output commands used to the console at the end of the script run.  Note that if *either* the config file debug value or the debug param is true the program will output commands.

.EXAMPLE
A sample command that uses the function or script, optionally followed by sample output and a description. Repeat this keyword for each example.

.INPUTS
The .NET types of objects that can be piped to the function or script. You can also include a description of the input objects.

.OUTPUTS
The .NET type of the objects that the cmdlet returns. You can also include a description of the returned objects.

.NOTES
@Author: epopisces (github.com/epopisces)

.LINK
The name of a related topic. The value appears on the line below the ".LINK" keyword and must be preceded by a comment symbol # or included in the comment block.

Repeat the .LINK keyword for each related topic.
#>

################################################################################
#region #*      Variables
################################################################################
#? The following variables can be modified by the user.
param ([string]$ConfigFilePath = "config.conf", [bool]$debug=$false)
$LogFolderPath = "logs"

$commandHistory = [ordered]@{}
$commandCount = 0

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

#! Modify to include any PS module dependencies: remove if none
# If ( -not ( Get-Module -ListAvailable -Name ModuleName ) ) {
#   Install-Module ModuleName
#   Import-Module ModuleName
# }

#! Modify to include any non-PS dependencies (eg Azure CLI): remove if none
# function Confirm-Dependency {
#   $azCli = az version | ConvertFrom-Json
#   if ($?) {   # if prior command doesn't error out
#     #? further testing here, eg checking return value
#   } else {
#     Write-Host "Dependency not installed"
#     Write-Host "Please install the dependency and try again"
#     exit 1
#   }
# }
#endregion


################################################################################
#region #*      Supporting Functions
################################################################################

function Initialize-FromConfig {
  param (
    [string]$configFilePath,
    [bool]$debug=$false,
    [string]$env=$false
  )

  $config = Get-Content -Path $configFilePath | ConvertFrom-Json
  
  # overrides from params
  if ( $debug -eq $true ) {
    $config.debug = $true
  }

  if ( $env -ne $false ) {
    $config | Add-Member -MemberType NoteProperty -Name "currentEnv" -Value $env
  } else {
    $config | Add-Member -MemberType NoteProperty -Name "currentEnv" -Value $config.defaultEnvironment
  }

  return $config
}

function Verb-Noun {
  [CmdletBinding()]
  param (
    
  )
  
}
#endregion


################################################################################
#region #*      CLI Menu
################################################################################

function Build-Menu {
  param (
    [object[]]$config
  )

  $submenu = [ordered]@{}

  #! here submenus could be populated from add'l data present in object
  # ForEach ( $item in $config.environments.$($config.currentEnv).virtualMachines ) {
  #   $itemName = $item.name
  #   if ( $item.powerState -eq "VM running" ) {
  #     $submenu["$itemName | $($item.powerState)"] = "Stop", "Remote into VM", "Refresh"
  #   }
  #   else {
  #     $submenu["$itemName | $($item.powerState)"] = "Start", "Refresh"
  #   }
  # }

  $generalMenu = [ordered]@{
    "Header1" = "Run", "Edit", "View"; # example menu item list
    "Header2" = "Create", "Read", "Update", "Delete"; # example menu item list
  }

  return $submenu + $generalmenu
}

function Show-Menu {
  param (
    [string]$menuTitle = 'My menu',
    [string]$lastAction = $false,
    [string]$debug = $false,
    $menu
  )

  $centeredTitle = ("| $(" " * ( ( 54 - $menuTitle.Length ) / 2)) $menuTitle $(" " * ( ( 54 - $menuTitle.Length ) / 2))").substring(0, 58)+" |"
  if (!( $debug )) {
    Clear-Host
  }

  if ( $lastAction -ne $false ) {
    Write-Host $lastAction -ForegroundColor DarkGreen
    Write-Host ""
  }
  Write-Host " __________________________________________________________ "
  Write-Host $centeredTitle
  Write-Host "|==========================================================|"
  $menuIndex = 0
  $menuOptions = [ordered]@{}

  ForEach ( $menuSection in $menu.Keys ) {
    Write-Host "|" -NoNewLine

    if ( $menuSection -Like "*|*" ) { 
      
      $color = "DarkCyan"
      $context = $menuSection.split("|")[0].trim()
      
      $commandHistory["INFO: Display $context Menu section"] = "$menuSection"
    } else { 
      $color = "DarkGray" 
      $context = ""
    }

    Write-Host ("$(" " * ( ( 57 - $menuSection.Length ) / 2)) $menuSection $(" " * ( ( 57 - $menuSection.Length ) / 2))").substring(0, 58) -ForegroundColor $color -NoNewLine
    Write-Host "|"
    
    ForEach ( $menuItem in $menu[$menuSection] ) {
      $menuIndex += 1
      $menuOptions["$menuIndex"] = $menuItem, $context
      Write-Host ("| $menuIndex. $menuItem").PadRight(58," ")"|"
    }

  }
  
  Write-Host "|__________________________________________________________|"
  return $menuOptions
}

function Show-DebugOutput {
  param (
    [object[]]$config
  )

  if ( $config.debug ) {
    Clear-Host
    ForEach ( $command in $commandHistory.Keys ) {
      Write-Host "--$($command)-------------------------------------".substring( 0, 60 ) -ForegroundColor DarkGreen
      Write-Host $commandHistory[$command]
      Write-Host ""
    }
    Pause # in case they ran the script via double-click, prevents term from closing
  }
}

function Select-MenuOption {
  param (
    [object[]]$config,
    [string]$lastAction = $false,
    [string]$debug = $false,
    $menu
  )

  do {
    $menuOptions = Show-Menu -LastAction $lastAction -Menu $menu -Debug $config.debug
    $selectNum = (Read-Host "Select an option (or 'Q' to quit): ").toLower()
    
    if ( $selectNum -eq "q" ) {
      $action = 'q' 
    } else {
      $action, $vmName = $menuOptions[$selectNum]
    }
  
    switch ($action) {
      'Run' {
        # Description
        $result = "doing a thing here"
        $lastAction = "Ran by $result."
      } 'Edit' {
        # Description
        $result = "doing a thing here"
        $lastAction = "Edited by $result."
      } 'View' {
        # Description
        $result = "doing a thing here"
        $lastAction = "Viewed by $result."
      } 'Delete' {
        # Description
        $result = "doing a thing here"
        $lastAction = "Deleted by $result."
      } 'Create' {
        # Description
        $result = "doing a thing here"
        $lastAction = "Created by $result."
      } 'Update' {
        # Description
        $result = "doing a thing here"
        $lastAction = "Updated by $result."
      } "View Help and Documentation" {
        Start-Process "https://helpsite.com/path/"
        $lastAction = "Launched helpsite in browser window."
      } default {
        # $lastAction = "Invalid option - please try again."
  
        # Write-Host $lastAction
      }
    }
  }
  until ($action -eq 'q')
}

#endregion


################################################################################
#region #*      Main Program Loop
################################################################################

$Config = Initialize-FromConfig -ConfigFilePath $configFilePath -Debug $debug -Env $env

# can perform add'l functions here to enrich object data, attribs

$menu = Build-Menu -config $config
$lastAction = $false
Select-MenuOption -config $config -LastAction $lastAction -menu $menu -debug $config.debug


#endregion

Show-DebugOutput -labBench $labBench
Write-Host "Exiting..."

# Stop Logging
Stop-Transcript

break

# Dev References (not user references, which should be included in .LINKs at top)