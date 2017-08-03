#!/usr/bin/perl -w

my $in = shift;
my $out = shift;
open IN, $in or die $!;
open OUT, ">$out/$in.rename" or die $!;
my $name = join ".", (split/\./, $in)[0,1];

while(<IN>){
    next if(/WARNING/);
    next if(/^#/);
    next if(/\[/);
    print OUT "$name\t$_";
}
