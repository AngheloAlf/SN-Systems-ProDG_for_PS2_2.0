/* This is just the basic idt.ld linker script file, except that it has
   a different OUTPUT_ARCH to force the linker into r5900 mode which
   uses 32bit addresses.  */

ENTRY(_start)
OUTPUT_ARCH("mips:5900")
OUTPUT_FORMAT("elf32-littlemips")
GROUP(-lc -lidt -lgcc)
SEARCH_DIR(.)
__DYNAMIC  =  0;

/*
* Allocate the stack to be at the top of memory, since the stack
* grows down.  (The first access will pre-decrement to the top of memory.)
*/
PROVIDE (__stack = 0);

/*
* The following two init_hook symbols are referenced by the supplied
* crt0 startup code.  If they are set to a non-zero value by
* linking in a routine by that name, they will be called during startup.
* If some other startup code is used, the following definitions are
* not needed.
*/
PROVIDE (hardware_init_hook = 0);
PROVIDE (software_init_hook = 0);

SECTIONS
{
  . = 0x00010000;
  .text : {
     _ftext = . ;
    *(.init)
     eprol  =  .;
    *(.text)
    *(.mips16.fn.*)
    *(.mips16.call.*)
    *(.rel.sdata)
    *(.fini)
     etext  =  .;
     _etext  =  .;
  }
  . = .;
  .rdata : {
    *(.rdata)
  }
   _fdata = ALIGN(16);
  .data : {
    *(.data)
    CONSTRUCTORS
  }

/*
* The processor has a number of instructions that can access data more
* efficiently with a restricted offset range, in this case +-32K.
* Therefore, small data items are collected together in memory and accessed
* relative to _gp.  Since the maximum size of the data is 64K, we ensure that
* all of that data can be accessed by setting _gp to the middle of the area
* (beginning + 32K).
*/
  . = ALIGN(8);
  _gp = . + 0x8000;
  __global = _gp;
  .lit8 : {
    *(.lit8)
  }
  .lit4 : {
    *(.lit4)
  }
  .sdata : {
    *(.sdata)
  }
  . = ALIGN(4);
   edata  =  .;
   _edata  =  .;
   _fbss = .;
  .sbss : {
    *(.sbss)
    *(.scommon)
  }
  .bss : {
    _bss_start = . ;
    *(.bss)
    *(COMMON)
  }
   end = .;
   _end = .;

  /* DVP overlay support */
  .DVP.ovlytab 0 : { *(.DVP.ovlytab) }
  .DVP.ovlystrtab 0 : { *(.DVP.ovlystrtab) }

  /* interrupt vectors, for BEV=0 */
  .eit_v 0x80000180 : { *(.eit_v) }
}
