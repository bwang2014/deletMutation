#!/usr/bin/perl -w
use strict;

die "perl $0 <geno_type_file> <out_put.file>\n" unless(@ARGV == 2);

my $geno_file = shift;
my $out = shift;

my %genoInf;
my %sample;
open IN, $geno_file or die $!;
open OUT, ">$out" or die $!;
while(<IN>){
    chomp;
    my @inf = split/\s+/;
    if(/^Chr/){
	for my $i (3..($#inf-1)){
	    $sample{$i} = $inf[$i];
	}
    }else{
    for my $i (3..($#inf-1)){
	next if($inf[$i] eq $inf[$#inf]); #$inf[$#inf] is ancestral allele. 
	if(exists $genoInf{$i}){
	    push @{$genoInf{$i}}, $inf[$i];
	}else{
	    $genoInf{$i} = [$inf[$i]];
	}
    }
    }
}

#print "@{$genoInf{5}}\n";

foreach my $sample (sort keys %genoInf){
    my @stat_inf = geno_stat($genoInf{$sample});
    my $stat_line = join "\t", @stat_inf;
    print OUT "$sample\t$sample{$sample}\t$stat_line\n";
}

#my @test = ("A", "G", "X");
#print "@test\n";
#my @he = geno_stat(\@test);
#print "@he\n";

sub geno_stat{
    my $list = $_[0];
    my @geno = @$list;
#    print "@geno\n";
    my ($A, $G, $C, $T, $missing, $het) = (0, 0, 0, 0, 0, 0);
    foreach my $i (0..$#geno){
	if($geno[$i] eq 'A'){
	    $A += 1;
	}elsif($geno[$i] eq 'G'){
	    $G += 1;
	}elsif($geno[$i] eq 'C'){
	    $C += 1;
	}elsif($geno[$i] eq 'T'){
	    $T += 1;
	}elsif($geno[$i] eq '-'){
	    $missing += 1;
	}else{
	    $het += 1;
	}
    }
     #my @stat = ();
     #push @stat, $A, $G, $C, $T, $missing, $het;
     #print @stat."\n";
     #return @stat;
    return($A, $G, $C, $T, $missing, $het);

}
