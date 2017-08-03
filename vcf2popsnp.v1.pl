#!/usr/bin/perl -w
use strict;
#===============================================================================
#         FILE:  popsnp.pl
#        USAGE:  perl popsnp.pl
#  DESCRIPTION:  vcf 2 add_ref 
#===============================================================================
die "perl $0 <input samtools.vcf> <output addref.prefix> \n"unless(@ARGV == 2);
my $vcf = shift;
my $pre = shift;
my ($minD,$maxD,$GQ) = (2,10000,5);
#my $qual = 20;
my $Amis = 1.00; ## ALLmis
my %allel = (
	'--' => '-',
	'AA' => 'A', 'TT' => 'T', 'CC' => 'C', 'GG' => 'G',
	'AC' => 'M', 'CA' => 'M',
	'AG' => 'R', 'GA' => 'R',
	'AT' => 'W', 'TA' => 'W',
	'CG' => 'S', 'GC' => 'S',
	'CT' => 'Y', 'TC' => 'Y',
	'GT' => 'K', 'TG' => 'K'
);

open OSNP,">$pre.snp" or die "can't open output file\n";
open OGENO,">$pre.geno" or die "can't open output file\n";

if($vcf=~/gz$/){
	open V, "<:gzip","$vcf" || die $!;
}else{
	open V, "$vcf"||die"$!";
}

while(<V>){
	chomp;
	next if(/^#/);
	next if(/INDEL/);
	my @line=split;
	#next if($line[5]<$qual);
	$line[3]=~tr/acgt/ACGT/;
	my $head = "$line[0]\t$line[1]\t$line[3]\t";

	if($line[4]=~/,/){#multiple alleles
		$line[4]=~tr/acgt/ACGT/;
		my @alt=split /,/,$line[4]; #A,C,G
		my %code;
		for my $i (0..$#alt){
			my $ii=$i+1;
			$code{$ii} = $alt[$i];
		}
		$code{'0'} = $line[3];
		my $geno="";
		my $snp="";
		for my $i (9..$#line){
			my ($gt,$dp,$gq)=(split /:/,$line[$i])[0,2,-1];
			#my $gt=(split /:/,$line[$i])[0];
			my @temp=split /\//, $gt;
			my $key = $code{$temp[0]}.$code{$temp[1]};
			#if($gq<$GQ){
				#$snp .= " -";
				#$geno .= " -";
			#}
			#els
			$dp=0 if($dp eq '.');
			if($dp<$minD || $dp>$maxD){
				$snp .= "- ";
				$geno .= "- ";
			}
			elsif($allel{$key} eq $line[3]){
				$snp .= "- ";
				$geno .= "$allel{$key} ";
			}
			else{
				$snp .= "$allel{$key} ";
				$geno .= "$allel{$key} ";
			}
		}
		my $snpmis = () = $snp =~ m/-/g;
		my $genomis = () = $geno =~ m/-/g;
		if( $snpmis/($#line-8) >= $Amis ){
			next;
		}
		else{
			print OSNP "$head"."$snp\n";
		}
		if( $genomis/($#line-8) >= $Amis ){
			next;
		}
		else{
			print OGENO "$head"."$geno\n";
		}
	}else{
		$line[4]=~tr/acgt/ACGT/;
		my %code = ( '0' => $line[3], '1' => $line[4], '.' => '-' );
		my ($geno,$snp);
		for my $i (9..$#line){
			my ($gt,$dp,$gq)=(split/:/, $line[$i])[0,2,5];
			#my $gt=(split /:/,$line[$i])[0];
			$dp=0 if($dp eq '.');
			my @temp=split /\//, $gt;
			my $key = $code{$temp[0]}.$code{$temp[1]};
			#if($gq<$GQ){
				#$snp .= " -";
				#$geno .= " -";
			#}els
			if($dp<$minD || $dp>$maxD){
				$snp .= "- ";
				$geno .= "- ";
			}
			elsif($allel{$key} eq $line[3]){
				$snp .= "- ";
				$geno .= "$allel{$key} ";
			}
			else{
				$snp .= "$allel{$key} ";
				$geno .= "$allel{$key} ";
			}
		}
		my $snpmis = () = $snp =~ m/-/g;
		my $genomis = () = $geno =~ m/-/g;
		if( $snpmis/($#line-8) >= $Amis ){
			next;
		}
		else{
			print OSNP "$head"."$snp\n";
		}
		if( $genomis/($#line-8) >= $Amis ){
			next;
		}
		else{
			print OGENO "$head"."$geno\n";
		}
	}
}
close V;
close OSNP;
close OGENO;
