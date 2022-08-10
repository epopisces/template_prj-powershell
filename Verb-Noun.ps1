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

# Imports

# Logging

# Dependency Handling

# Config File Handling

# User Menu (if needed)

# Sundry Functions

# Main Function

# Dev References )not user references, which should be included in .LINKs at top)

import logging, argparse    #? remove argparse if the script won't accept arguments
#? from tools.{toolname} import {toolname}_api as {toolname}

#? Optional imports that may be helpful
#?   toml (configuration file format for scripts)
#?   re (regex)
#?   os (get files or folders, or environment variables)

class PrimaryClass(object):
    """Oneline description (can have longer description below, if desired)
    
    Attributes:
        attr1 (str):        A required or optional attribute used in __init__
        attr2 (bool):       Another required or optional attribute used in __init__

    Methods:    
        method1()           One line explanation of method
        method2()           One line explanation of method
        method3()           One line explanation of method
    
    """
    
    def __init__(self):
        #? any stuff that needs to happen when this is initialized (like grabbing credentials,
        #? authentication, setting attributes equal to an initial value) happens here
        return

if __name__ == '__main__':
    # * Init logging

    # * Init argument handling.  Will automatically provide '-h, --help' functionality
    #? See https://docs.python.org/3/howto/argparse.html for more details
    parser = argparse.ArgumentParser(description="Write a brief description of the script here")
    parser.add_argument('-e','--examplearg', default=False, type=str, help='an example string arg')

    args = parser.parse_args() #? Any argument can be referenced by args.argname, eg 'args.examplearg'

    # * Init Class
    classexample = PrimaryClass()
    print(classexample.__doc__)
