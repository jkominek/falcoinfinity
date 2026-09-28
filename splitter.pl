#!/usr/bin/env perl

use File::Basename;

my ($rom0, $rom1) = @ARGV;

$base = $rom0;
$base =~ s/^(.+)_.+$/$1/;

$basefileonly = basename($base);

system("dd", "if=${rom0}", "of=${base}_fixed.rom", "bs=32k", "skip=1");
system("z80dasm", "-g", "0x0000", "${base}_fixed.rom", "-o", "assembly/${basefileonly}_fixed.asm"); 

my @banks = (
    [ $rom0, 0 ],
    [ $rom0, 1 ],
    [ $rom1, 0 ],
    [ $rom1, 1 ],
    [ $rom1, 2 ],
    [ $rom1, 3 ]
);

my $i=0;
foreach my $row (@banks) {
    system("dd",
           "if=".$row->[0],
           "of=${base}_bank${i}.rom",
           "bs=16k",
           "count=1",
           "skip=".$row->[1]);
    system("z80dasm", "-g", "0x8000", "${base}_bank${i}.rom", "-o", "assembly/${basefileonly}_bank${i}.asm");
    $i ++;
}

