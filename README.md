# Falco Infinity reverse engineering

I dug some old dumb terminals out of storage and found that they seem
to be nearly unknown, though similar to some other moderately
documented Falco terminals.

So here's what we've got:

* roms - dumped from the terminals. very sure about the contents, each terminal had two sets of EPROMs in it, and they matched perfectly when read.
* pictures - various photos of the internals in varying states of disassembly and cleaning.
* docs - notes on how the thing works
* assembly - z80dasm generated assembly, along with the Makefile to confirm that the files recompile into exact matches with the original.

There's probably enough here to add support for the machine to MAME, along
side the other Falco terminals in there. I'm hoping with the PCB at hand
to sort out how the keyboard and sound work. I expect that the video ASIC
will have to be figured out via the code. Hence setting up for disassembly.
