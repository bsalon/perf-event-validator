#!/bin/bash

# TODO: arguments

# include working environment
. ./settings.sh

COUNTER=0

touch event_stats.err

while read LINE; do
	PERF_OPTIONS=`./parse_args.pl $LINE`

	perf stat $PERF_OPTIONS $COMMAND 2> event_stats_$COUNTER.log
	if [ $? -ne 0 ]; then
		grep -q "event syntax error" event_stats_$COUNTER.log
		if [ $? -ne 0 ]; then
			echo -e "$COUNTER \e[31m FAIL \e[m $LINE"
		else
			echo -e "$COUNTER \e[33m SKIP \e[m $LINE"
		fi
		(( COUNTER += 1 ))
		continue
	fi

	RESULT=`./parse_stat.pl $LINE < event_stats_$COUNTER.log`
	if [ "$RESULT" == "SKIP" ]; then
		echo -e "$COUNTER \e[33m SKIP \e[m $LINE"
	else
		CHECK=`echo $RESULT | bc` # FIXME
		if [ $CHECK -eq 1 ]; then
			echo -e "$COUNTER \e[32m PASS \e[m $LINE"
			echo -e "         \e[32m $RESULT\e[m"
		else
			echo -e "$COUNTER \e[31m FAIL \e[m $LINE"
			echo -e "	  \e[32m $RESULT\e[m"
			echo $COUNTER $LINE $RESULT >> event_stats.err
		fi
	fi

	(( COUNTER += 1 ))

done < events_list.txt

echo ALL PASSED/FAILED -\> 1/1
