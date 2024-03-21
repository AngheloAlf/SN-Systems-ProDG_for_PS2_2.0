SN Systems Playstation2 Compiler Tools for win32 Platform.

Version History

Version 2.73a
-------------

. -Wpromote-doubles now works in C++

Version 2.73
-------------

. Problem with -O2 debug info fixed.
. 128bit math problems fixed - compiler allows safe 128 bit ops such as
casting to/from int128's, but will not allow 128bit mathematics, which can
produce incorrect results if the upper 64 bits are used (this is a flaw in
the GCC compiler).
. Improvement to VSI error info format.

Version 2.72
-------------

. Problem with the 'split insn' compiler errors resolved.
. double/float flags added:

   -fdefault-single-float   -const floating point values are converted to
floats by default not doubles.
   -Wpromote-doubles  -less intrusive - compiler warns whenever consts are
promoted to doubles.

Version 2.71
------------

. Alignment problem in C++ fixed.

Version 2.7
-----------

Contains the following bugfixes / enhancements:

. Anonymous unions and structures fully supported in C/C++.
. In VSI, the correct error count is now displayed at the end of a build.
. Instantiation of members is now allowed in structures containing anoymous unions or structs (C++).
. Bug in variable length arguments fixed (problem also caused bug in stack alignment so that is fixed too).
. 'which alignment' patch incorporated (Author: Dylan Cuthbert).


Version 2.5
-----------

Contains Some bug fixes, upgrades and ability to use Anonymous Structures in C++ (in the same way the MicroSoft C++ Compiler does)

Bug fixes affect alignment in C++ - which were upgraded in version 1.6.0 of the Sony/Cygnus compiler, and GP optimisation, which now works properly.

Version 2
---------

This release has had incorporated into it all the feedback and bugfixes which were reported from the version 1 release, as well as the vu0 inline patch written by Dylan Cuthbert, activated in the same way, using eg -mvu0-use-vf0-vf31 (see the included readme in usr\local\dylan-vu0-patch).


These tools are based on the gcc 2.95.2 compiler source.  They have been created due to requests for a more advanced compiler than the default version of GCC that is currently supplied.

To install, it is assumed you have already installed and set up either 1.3.0, 1.6.0 or any future release of our win32 default compilers, also available on the website.

To install, simply unzip the files into the root of your drive with the SCE toolchain on.

There are two ways of using this new compiler, the recommended way is with the SN ps2cc tool, the alternative is with ee-gcc295.


Method 1:
---------

ps2cc is the SN Systems compiler driver, it automates the build process and can be used as a replacement for ee-gcc.
It is available for download off the website - installation and setup are extremely simple.
With ps2cc, change the following line in your sn.ini file to use the 2.95.2 compiler, if you are using the 160 toolchain:

.
.
.
compiler_path=c:\usr\local\sce\ee\gcc\lib\gcc-lib\ee\2.9-ee-991111

to

.
.
.
#compiler_path=c:\usr\local\sce\ee\gcc\lib\gcc-lib\ee\2.9-ee-991111
compiler_path=c:\usr\local\sce\ee\gcc\lib\gcc-lib\ee\2.95.2

This method means that you can switch between the two compilers simply by commenting out one or other of the lines.

invoking ps2cc will call the selected compiler.

Method 2
---------

Change your CC = calls in the makefile from ee-gcc to ee-gcc295, then you'll be calling the 2952 compiler instead of 160/130.

Source available free on request,

Any problems, queries, bug reports, please write to support@snsys.com

Regards,

Dave Brown
SN Systems compiler team
dave@snsys.com

September 2000.