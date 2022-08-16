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

sub printHelp
{
	say "Usage:";
	say "  cs <tool> [search string]";
	say "  ";
	say "try with the following tools:";
	system("ls $CS_DIR");
	exit 1;
}

sub filterCS
{
	my $file = $_[0];

	open(my $fh,'<', $file);
	my $obj;
	my $block = 0;

	while (my $line = <$fh>)
	{
		if (!$block && $line =~ /^([^>][^>][^#]*)\s*#\s*(.+)/) {
			push @list, {line => $1, desc => $2, block => 0};
		} elsif ($line =~ /^<</) {
			$block = 0;
			push @list, $obj;
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
	my $st = shift @_;

	foreach my $it (@list) {
		if ($it->{line} =~ /$st/) {
			say "$comment_char $it->{desc}";
			say "$it->{line}";
			say "";
		}
	}
}

# check input
if ( $ARGV[0] eq "" ) {
	printHelp();
}

my $file = "$CS_DIR/$ARGV[0]";
my $st = $ARGV[1] // ".*";

if ( $ARGV[2] ne "" ) {
	printHelp();
} elsif ( ! -f $file) {
	print "The cheatsheet '$file' does not exist, try with:\n";
	system("ls $CS_DIR");
	exit 1;
}

# main
filterCS($file);
printCS($st);
