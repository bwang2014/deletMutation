#!/usr/bin/perl
use strict;
use Getopt::Long;
use 

my ($indir, $outdir, $type, $thread);
Getopts(
    "indir:s" => \$indir,
    "outdir:s" => \$outdir,
    "t:i" => \$thread,
    "type:s" => \$type
);


