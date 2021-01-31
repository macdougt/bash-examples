#!/usr/bin/env perl

use strict;
use warnings;

my $file = ".bash_big_history";

undef $/;

open (my $fh, "< $file") || die "Sorry, I couldn't read $file.\n";
# Assume lines start with [, separate on that
my $content = <$fh>;
close $fh;

while ($content =~ //) {
  
}
