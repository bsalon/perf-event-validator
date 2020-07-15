#!/usr/bin/perl

my @event_line = @ARGV;
my $command_arg = '';

foreach (@event_line) {
	$command_arg .= " -e $_" if (/[\w\-]+/);
}

if ($command_arg eq '') {
	exit 1;
}

print $command_arg;
exit 0
