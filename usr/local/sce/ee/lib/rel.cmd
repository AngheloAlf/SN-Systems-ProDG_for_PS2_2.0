
SECTIONS {
	.text		ALIGN(128): { *(.text) }
	.data		ALIGN(128): { *(.data) }
	.rodata		ALIGN(128): { *(.rodata) }
	.rdata		ALIGN(128): { *(.rdata) }
	.gcc_except_table ALIGN(128): { *(.gcc_except_table) }
	.lit8     	ALIGN(128): { *(.lit8) }
	.lit4      	ALIGN(128): { *(.lit4) }
	.sdata		ALIGN(128): { *(.sdata) }
	.sbss		ALIGN(128): { *(.sbss) *(.scommon) }
	.bss		ALIGN(128): { *(.bss) }
}
