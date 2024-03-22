# SN Systems ProDG_for_PS2_2.0

This repository contains the SN toolchain for PS2, specifically the "GCC 2.95.2 (SN BUILD v2.73a)" version.

The files included in this repo are:

- `Setup.exe`: The original installer for the toolchain.
  - It requires the original Sony toolchain to be installed at `C:\usr\local\sce`, but just creating empty folders with that path bypasses the check.
- `ProDG for PlayStation2`: The folder installed at `C:\Program Files (x86)\ProDG for PlayStation2`.
  - It doesn't seem to contain anything too important, but it is kept for completeness sake.
- `usr`: The actual toolchain.
  - The compiler driver is located at `./usr/local/sce/ee/gcc/bin/ee-gcc295.exe`.
  - The backend tools are located at  `./usr/local/sce/ee/gcc/lib/gcc-lib/ee/2.95.2/`.
  - The binutils tools are located at `./usr/local/sce/ee/gcc/ee/bin`.

## Installer info

The installer gives the following information during installation:

```
ProDG for PlayStation2 version 2.0
-------------------------------------------------------

The following software can be installed by this package:

Debugger			version 1.50.08
Target Manager		version 2.28.15.0
EE Tools			version 1.6.0 r4
			version 2.95.2 v2.73
IOP Tools			version 1.6.0 r3
Assemblers		version 1.8.19.0
Linker			version 1.14d
DLL Linker		version 1.60
Utilities			version 1.00
Getting Started Guide	version 2.0

Notes
----------

You will need to have the Sony 1.6.X or 2.1.X libraries already installed 
(in a \usr\local\ directory) to be able to use this software.  If you do not 
have this installed you should exit setup now and install them, then rerun
this setup.

If you have any problems with this software, or the installation, please contact:
support@snsys.com.

Regards,
SN Support Team
```

