#!/usr/bin/perl -w

my $in = shift;
open IN, $in or die $!;
open OUT, ">$in.rename" or die $!;
my $name = join ".", (split/\./, $in)[0,1];

while(<IN>){
    next if(/WARNING/);
    print OUT "$name\t$_";
}
