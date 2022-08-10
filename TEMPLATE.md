# PowerShell Project Template

> Removing the work of formatting your code

One Paragraph of project description goes here

## Standard Usage, Broad Application

This template includes the most common code reused across projects, and is designed to apply to as broad a number of use cases as possible without creating extra work in cleanup or reduction.  Here are some explanations of how this is accomplished:

### Generating a Manifest
```powershell
New-ModuleManifest -Path C:\projectManifest.psd1 -ModuleVersion "1.0" -Author "epopisces"
```

### Logging


### Explicit Docstring

By explicitly declaring and printing a docstring (specifically '__doc__ = """stuff"""' & 'print(__doc__)'), both .py and in pyinstaller-packaged .exes can use the docstring.


### User 'Help'
```
./projectmain.py help
```
This will print the __doc__ docstring


### sys.exit(), not quit()

Using sys.exit() works in pyinstaller executables, whereas quit() only works in .py

## Author

<img alt="@epopisces" width="22" height="22" src="https://avatars2.githubusercontent.com/u/17202697?s=60&amp;v=4"> [Lucas Gallagher](https://github.com/epopisces)

## Works Cited
https://docs.microsoft.com/en-us/previous-versions/technet-magazine/ff458353(v=msdn.10)
