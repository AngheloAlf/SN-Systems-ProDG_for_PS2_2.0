#--------------------------------------------------------------------#
#                                                                    #
# Dylan's GCC inline asm patches                                     #           
#                                                                    #
# Developed by Dylan Cuthbert for Hagiwara Group                     #
# Sony Computer Entertainment Inc. Japan                             #
#                                                                    #
# Document Date:    11th July 2000                                   #
# Document Version: 1.0                                              #
#                                                                    #
#--------------------------------------------------------------------#
 
------------------------------------
 Distribution and License Agreement
------------------------------------
 

This package is freely distributable under the terms of the GPL
(Gnu Public License) agreement which is described in detail at
http://www.gnu.org/copyleft/gpl.html
 
If you distribute these patches, please also distribute this readme file.
 
---------
 Support
---------
 

The package is free and therefore, under the terms of the GPL (see
Section 11 of the GPL ), it is supplied "as-is", with no warranty or 
guarantee or support.  I will however entertain questions at 
dylan_cuthbert@hq.scei.sony.co.jp. You are not, however, guaranteed a
reply.
 
Also check http://www.geocities.com/dylan_cuthbert for a detailed list of 
inline asm dos and don'ts and other programmer-related links.
 

--------------
 Installation
--------------
 

1. Install the SCE GCC distribution source code.
2. Follow the steps in /usr/local/sce/1st_read/bldgcc_e.txt.
3. Before performing "make all" and after the installation of sce's
   patches, do the following:
4. cd /usr/local/sce/ee/gcc
5. patch -p0 < {path to this directory}/vu0-support
6. patch -p0 < {path to this directory}/which_alternative
7. patch -p0 < {path to this directory}/output_operand_bugfix
 
The patches have been tested against gcc version 2.9-ee-990721 and
gcc version 2.9-ee-991111 with no problems.
 
8. continue with the compilation and install of the SCE GCC
   distribution.
 

---------------
  THE PATCHES
---------------
 

  1. which_alternative
  2. output_operand_bugfix
  3. vu0-support
 

----------------------
 1. which_alternative
----------------------
 

The GCC inline asm problem:
 
When writing inline asm for VU0 you have to specify your arguments as "r" 
or "m" which determines whether the 128-bit value is passed to the inline 
asm by register or memory.  Both these options have their merits, but 
both have their downfalls:
 
"r"
 
This allows the compiler to do the loading and storing from memory, so if 
you have a number of consecutive inline asm functions the memory access 
is reduced greatly, it allows the compiler to do register optimization 
and eliminates a lot of unnecessary copies.  However, latency problems 
occur at the beginning and end of a block of inline asm usage because the 
compiler has to "lq r5, memory" and then, of course, in your inline asm 
macro you have a "qmtc2".  The same happens at the end with your inline 
asm's qmfc2, followed by the compiler's "sq".  It also wastes those 
registers at the beginning and end.
 
"m"
 
Reading/writing those 128 bit values directly from memory generates the 
simplest code and doesn't need any R5900 intervention at all.  Everything 
gets processed by lqc2/sqc2 and no R5900 registers are used.  
Unfortunately, the flip side of this coin is that the compiler knows 
*absolutely nothing* regarding what you are doing and can't do any 
optimizations with the 128 bit values you are using.  
 
Consider a c++ class that lets you treat a vu0 vector as an 
math-operate-able type.  ie.  vector_xyz1 value2 = value1 + value3.  This 
class is easy to write but if you use the "m" in your inline assembly you 
incur rather painful memory copies at each "=".  If you use "r" those 
copies disappear (as they do with regular integer math) but you incur the 
latency overheads at the beginning and end of the block of vector_xyz1 usage.
 
 
I researched further into this and read all the inline asm documents I 
could find, (check http://www.geocities.com/dylan_cuthbert for more 
inline asm info) and discovered that gcc actually *can* choose between
"r" or "m" depending on what the optimization pass thinks is a best fit.  
Unfortunately the current implementation *relies* on the assembler 
mnemonic (of all the stupidest things) to support access to different 
types.   You can actually write:
 
asm
(
  " qmtc2 %0, vf1       \n"
  : : "r,m" (value)
);
 
The compiler will correctly choose whether it is better to use memory or 
a register (register has a higher priority because it is first) depending 
on the surrounding code. Unfortunately all GCC does is supply %0 as "r5" 
or "0(r5)" which of course the qmtc2 mnemonic can't cope with. (never mind 
the fact that lqc2 needs the operands in REVERSE order to qmtc2)
 
So I made a remarkably simple patch to gcc to remove that reliance on 
assembler mnemonics.  It allows you to check the "alternative" with a
simple ".if" directive within the inline assembler.
 
The above code becomes:
 
asm
(
  "  .if %A0             \n"    // %An returns ( which_alternative == n ) ? 1 : 0
  "  qmtc2 %0,vf1        \n"
  "  .else               \n"
  "  lqc2  vf1, %0       \n"
  "  .endif              \n"
  : : "r,m" (value)
);
 
"%An" is converted to either 0 or 1 depending on whether the compiler 
chose the first constraint or the second constraint.
 
You can do far more complex things with this, for example:
 
#define LoadValue( value )      \
asm                             \
(                               \
  "  .if %A0                \n" \
  "  load from register     \n" \
  "  .endif                 \n" \
                                \
  "  .if %A1                \n" \
  "  load from memory       \n" \
  "  .endif                 \n" \
                                \
  "  .if %A2                \n" \
  "  load from integer      \n" \
  "  .endif                 \n" \
                                \
  "  .if %A3                \n" \
  "  load from float        \n" \
  "  .endif                 \n" \
                                \
  : : "r,m,i,f" (value)         \
);
 
This macro allows you to, with one single implementation, support a number 
of different types automatically.
 

--------------------------
 2. output_operand_bugfix
--------------------------
 

This bug-fix is simply an already-fixed bug that I regressed from the most 
recent source for GNU GCC found on http://www.gnu.org/software/gcc.
 
It fixes the problem when using "+r" (input/output constraint) and getting 
the error "output constraint x is not written back to memory".
 
Install this patch and the error goes away.
 

--------------------------
 3. vu0-support
--------------------------
 

Summary:
 
This patch is the most detailed of them all.  It involves a major 
extension to the R5900 "machine description" to enable support for 
the automatic allocation of VU0's internal register set.
 
Usage:
 
This support is enabled via the command line switch -mvu0-use-vf0-vf31.
At this point in time, you can change only the "vf31" part of the option.  
For example, -mvu0-use-vf0-vf15 will disable the automatic allocation of 
vf16 through to vf31.
 
The new inline asm operand constraint "j" can be used to request a VU0 
register.  For example:
 
extern inline long128 vector_sqr( long128 vec )
{
    asm( "vmul %0, %0, %0" : "+j" (vec) )
    return vec;
}
 
The "%0"s get expanded to vfxx where xx is a register automatically 
allocated by the compiler.  Note: if you haven't specified the 
-mvu0-use-vf0-vf31 option you will get an appropriate error message 
because the compiler can't allocate the requested register class.
 
Note, this extended feature is intended mainly to be used in inline 
functions.  Note: you can specify "extern inline" (see GCC documentation) 
to avoid GCC producing a physical copy of the function.  Without 
specifying "extern" each inline asm is physically created and 
added to the object file being compiled, only to be eliminated at link 
time.
 
Here is a more complicated example:
 
extern inline long128 vector_add( long128 vec1, long128 vec2 )
{
    long128 result;
    
    asm( "vadd %0, %1, %2"
       : "=j" ( result )
       : "j" ( vec1 ), "j" ( vec2 ) 
       );
    
    return result;
}
 

Extra Notes On Usage:
 

1. There is no need to specify volatile with these kind of asm 
statements.  There are no compiler-unseen side-effects.  If "result" is 
discovered, after optimization, to not have been used, this asm statement 
will automatically be deleted.  The asm statement will also be moved 
around with relation to surrounding code depending on what the 
optimization thinks best.  This is in stark contrast to a volatile'd asm 
statement which cannot be moved or removed no matter what.
 
If the asm instructions uses registers whose lifetimes extend past the 
lifetime of the asm instruction (such as VU0's Q register) then volatile 
*must* be specified.  For example:
 
    asm( "divq Q, %0, %0; vwaitq; vmulq %0, %0, Q" : "+j" (input) );
 
is fine, however:
 
    asm( "divq Q, %1, %1; vadd %0, %0, %1"
       : "+j" (input_copy) : "j" (input) );
       
    asm( "vwaitq; vmulq %0, %0, Q"
       : "+j" (input) );
 
is a no-no unless you specify volatile.  Notice the lifetime of Q spreads 
from the first asm to the second.  Without volatile you might find another 
asm that uses Q being inserted before the second line by the optimizer.
 

2. An asm statement with no outputs is automatically declared
volatile by the compiler so you should try to avoid asm statements with no 
outputs.  More specifically, an output-less asm statement tends to be 
caused when addresses are passed with the "r" constraint.  You should pass
output addresses with "=m" or "+m".  A more detailed explanation of the 
pitfalls and rules of inline asm programming can be found at my web page 
listed above under "Support".
 

3. You can pass values in specific registers to micro code by doing 
the following:
 
register long128 vec1 asm( "vf10" );
register long128 vec2 asm( "vf12" );
 
asm volatile ( "vcallmsr MyVu0Prog" : : "j" (vec1), "j" (vec2) );
 
Note, that vf10 and vf12 (in this example) are *undefined* at any point 
other than within the asm statement (in this example).  That is. they are 
only put into vf10 or vf12 when they are used; the spaces of code 
inbetween could use vf10 or vf12 to hold other values if the compiler so 
chooses.
 
4. If old style code exists that explicitly uses certain VU0 registers, 
you must now be sure to specify the vf registers that the asm statement is 
using in the clobber list.
 
For example:
 
  asm volatile ( "vadd vf2, vf3, vf4" );
 
should become
 
  asm volatile( "vadd vf2, vf3, vf4" : : : "vf2", "vf3", "vf4" );
 

5. Try not to take the address or reference of a long128 - the compiler is 
much better at optimizing direct uses of a 128 bit value.  Taking an 
address or reference causes the compiler, unnecessarily, to have to 
physically store the value into memory (normally the stack) which is 
something you want to avoid at all costs (memory access is slow and 
usually unnecessary).
 

Caveats:
 

An unintended side-effect is that GCC will allocate a VU0 register in 
order to facilitate a 128 bit move if no general registers are available.  
This can happen in any code that uses 128 bit values - even if there is no 
code nearby that has specified the "j" register constraint.
 
In light of this, it is best to compile object files that contain Irq 
or Exception handlers without the -mvu0-use-vf0-vf31 option, just to be 
safe.
 
This isn't entirely a bad thing because you actually receive a speed gain 
in functions that are using general registers heavily.
 
 
 
Good Luck!
 
Dylan Cuthbert
Hagiwara Group
Sony Computer Entertainment Inc.
 