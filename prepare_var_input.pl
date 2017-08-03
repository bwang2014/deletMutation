#!/usr/bin/perl -w
#
#
my $line = "";
while(<>){
    chomp;
    next if(/^$/);
    my @inf = split/\t/;
    if($inf[0] ne $line){
	open VAR, ">$inf[0].subst" or die $!;
        #print VAR $_."\n";;
	print VAR "$inf[1]\n";
	$line = $inf[0];
    }else{
        # print VAR $_."\n";;
	print VAR "$inf[1]\n";
    }
}
