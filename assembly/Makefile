test: 189733_000.rom 189733_001.rom  921104_000.rom 921104_001.rom
	cmp 189733_000.rom ../roms/189733_000.rom
	cmp 189733_001.rom ../roms/189733_001.rom

	cmp 921104_000.rom ../roms/921104_000.rom
	cmp 921104_001.rom ../roms/921104_001.rom


%_000.rom: %_bank0.rom %_bank1.rom %_fixed.rom
	cat $^ > $@

%_001.rom: %_bank2.rom %_bank3.rom %_bank4.rom %_bank5.rom
	cat $^ > $@

%.rom : %.asm
	z80asm $< -o $@
