#!/usr/bin/perl

#    Format to add more entries: ";
#
#    - add command with description";
#    cmd  # description";
#
#    - adding a block example';
#    >> description';
#    line1";
#    line2";
#    <<';


use strict;
use feature "say";

my $BASE_DIR='/home/cano/git/cheat-sheets';
my $CS_DIR="$BASE_DIR/cheatsheets";
my @list = ();

my $comment_char = "//";
my $look_for_all = '_';

sub printHelp
{
	say "Usage:";
	say "  cs <tool> [search string]";
	say "  ";
	say "use '*' tool to look for in every file";
	say "try with the following tools:";
	system("ls $CS_DIR");
	exit 1;
}

sub filterCS
{
	my $file = $_[0];
	my $st = $_[1];

	open(my $fh,'<', $file);
	my $obj;
	my $block = 0;

	while (my $line = <$fh>)
	{
		if (!$block && $line =~ /^([^>][^>][^#]*)\s*#\s*(.+)/) {
			my $l = $1;
			my $d = $2;
			if ($d =~ /$st/ || $l =~ /$st/) {
				push @list, {line => $l, desc => $d, block => 0};
			}
		} elsif ($line =~ /^<</) {
			$block = 0;
			if ($obj->{desc} =~ /$st/ || $obj->{line} =~ /$st/) {
				push @list, $obj;
			}
		} elsif ($block) {
			$obj->{line} .= $line;
		} elsif ($line =~ /^\>\>\s*(.*)/) {
			$obj = { line => "", desc => $1, block => 1};
			$block = 1;
		}
	}

	close $fh;
}

sub printCS
{
	foreach my $it (@list) {
		say "$comment_char $it->{desc}";
		say "$it->{line}";
		say "";
	}
}


# check input
if ( $ARGV[0] eq "" ) {
	printHelp();
}

my $filename = $ARGV[0];
my $file = "$CS_DIR/$filename";
my $st = $ARGV[1] // ".*";

if ( $ARGV[2] ne "" ) {
	printHelp();
} elsif ( ! -f $file && $filename ne $look_for_all) {
	print "The cheatsheet '$file' does not exist, try with:\n";
	system("ls $CS_DIR");
	exit 1;
}


# main
if ($filename eq $look_for_all) {
	opendir my $dh, $CS_DIR;
	while ( my $f = readdir ($dh)) {
		filterCS("$CS_DIR/$f", $st);
	}
	close $dh;
} else {
	filterCS($file, $st);
}

printCS();
