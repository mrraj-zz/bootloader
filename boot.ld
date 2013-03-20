OUTPUT_FORMAT("binary")
SECTIONS {
	. = 0x7c00;
	.text : {
		.begin = .;
		boot.o	(.text);
		* (.text);
		* (.data);
		. = .begin + 510;
		boot.o (.boot_signature);
	}
}
