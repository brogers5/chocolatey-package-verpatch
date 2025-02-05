## Verpatch

Verpatch is a command line tool for adding and editing the version information of Windows executable files (applications, DLLs, kernel drivers) without rebuilding the executable.

It can also add or replace Win32 (native) resources, and do some other modifications of executable files.

Verpatch sets `ERRORLEVEL` 0 on success, otherwise `ERRORLEVEL` is non-zero. **Verpatch modifies files in place, so please make copies of precious files.**

### Usage Statement

```console
Usage: verpatch filename [version] [/options]
Options:
 /va - create the version resource. Use when the file has no version info.
 /s name "value" - add or replace any version resource string.
                   name: standard or custom attribute name. See below.
 /pv <version> - specify Product version
           /prodver, /productversion - same as /pv
 /fn - preserve Original Filename, Internal Name in the file version info
 /vo - output the file version info in RC format
 /xi - test mode, does not modify the file
 /vft2 num - specify driver type (one of VFT2_ values defined in winver.h)
 /rpdb - remove path to .pdb in debug information
 /rf #hex-id file - add a raw binary resource from file (see the readme)
 /noed - discard any extra data appended at the end of file
 /sc "comment" - same as /s comment "comment string"
 /langid <number> - language id for new version resource; use with /va. Default=LN.
 /high - interpret less than 4 version parts as higher numbers

Examples:
  verpatch d:\foo.exe /va 1.2.3.4 /s desc "my program"
  verpatch d:\foo.dll 1.2.33.44 /s comment "fixed this and that"
  verpatch d:\foo.dll "33.44 release"
  verpatch d:\foo.dll /high 1.2.33-beta5
  verpatch d:\foo.exe 1.2.3.4 /rf #9 embedded.dll

Alternative attribute names to use with /s (see documentation for details):
  comment company description|desc InternalName|title
  copyright|(c) LegalTrademarks|tm|(tm) ProductName|product
  PrivateBuild|private|pb  SpecialBuild|build|sb
```

For more information (e.g., example details, reference materials, notes, known issues, etc.), refer to [the readme file](https://github.com/pavel-a/ddverpatch/blob/1.0.15/verpatch-ReadMe.txt).
