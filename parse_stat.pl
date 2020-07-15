#!/usr/bin/perl

@event_line = @ARGV;
$equation = '';
@operators = ("/", "*", "-", "+", "<", "<=", "==", ">=", ">", "!=");

$counter = 0;
$line_size = @event_line;

while (<STDIN>) {
	s/\n//;
	s/\xe2\x80\xaf//g; # remove narrow no-break space

	$is_op = 0;
	foreach $op (@operators) {
		if ($event_line[$counter] eq $op) {
			$equation .= "$op ";
			$is_op = 1;
			++$counter;
			last;
		}
	}

	if (/^([\s\d\h,]+)@event_line[$counter]/) {
		$num = "$1";
		$num =~ s/[^\d+]//g;
		$equation .= "$num ";
		++$counter; #
	} else {
		if ($is_op == 0) {
			# FIXME: SKIP test
		}
	}

	if ($counter >= $line_size) {
		last;
	}
}

if ($counter < $line_size) {
	print "SKIP";
} else {
	print "$equation";
}

exit 0
