@echo off
@echo AR      = %PS2_DRIVE%:/usr/local/sce/iop/gcc/bin/iop-elf-ar> PathDefst1
@echo AS      = %PS2_DRIVE%:/usr/local/sce/iop/gcc/mipsel-scei-elfl/bin/as> PathDefst2
@echo CC      = %PS2_DRIVE%:/usr/local/sce/iop/gcc/bin/iop-elf-gcc> PathDefst3
@echo GCC     = %PS2_DRIVE%:/usr/local/sce/iop/gcc/bin/iop-elf-gcc> PathDefst4
@echo LD      = %PS2_DRIVE%:/usr/local/sce/iop/gcc/mipsel-scei-elfl/bin/ld> PathDefst5
@echo NM      = %PS2_DRIVE%:/usr/local/sce/iop/gcc/bin/iop-elf-nm> PathDefst6
echo SIZE    = %PS2_DRIVE%:/usr/local/sce/iop/gcc/bin/iop-elf-size> PathDefst7
echo STRIP   = %PS2_DRIVE%:/usr/local/sce/iop/gcc/bin/iop-elf-strip> PathDefst8
echo RANLIB  = %PS2_DRIVE%:/usr/local/sce/iop/gcc/bin/iop-elf-ranlib> PathDefst9
echo OBJCOPY = %PS2_DRIVE%:/usr/local/sce/iop/gcc/bin/iop-elf-objcopy> PathDefst10
echo OBJDUMP = %PS2_DRIVE%:/usr/local/sce/iop/gcc/bin/iop-elf-objdump> PathDefst11
echo IFIXUP  = iopfixup> PathDefst12
echo ILBGEN  = ioplibgen> PathDefst13
echo ILBLD   = ioplibld> PathDefst14
echo ILBDUMP = ioplibdump> PathDefst15
echo BIN2OBJ = bin2elf> PathDefst16

@copy PathDefst1+PathDefst2+PathDefst3+PathDefst4+PathDefst5+PathDefst6+PathDefst7+PathDefst8+PathDefst9+PathDefst10+PathDefst11+PathDefst12+PathDefst13+PathDefst14+PathDefst15+PathDefst16 PathDefs
del PathDefst*



