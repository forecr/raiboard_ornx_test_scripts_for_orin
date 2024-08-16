#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

sleep_time=0.3

function kill_gpioset_bg {
	# $1 -> GPIO chip
	# $2 -> GPIO index
	if [ $(ps -t | grep gpioset | grep "$1 $2" | wc -l) -eq 1 ]; then
		PID_GPIOSET_BG=$(ps -t | grep gpioset | grep "$1 $2" | awk '{print $1;}')

		kill $PID_GPIOSET_BG

		if [ $(ps -t | grep gpioset | grep "$1 $2" | wc -l) -eq 1 ]; then
			echo "Unable to kill process $PID_GPIOSET_BG"
		fi
	fi
}

function run_gpioset_out {
	# $1 -> GPIO chip
	# $2 -> GPIO index
	# $3 -> output value

	# If there is a gpioset command is working in background (for the selected GPIO), kill it
	kill_gpioset_bg $1 $2

	# Run the gpioset command in background (to keep the GPIO value continuously)
	gpioset --mode=signal $1 $2=$3 &
}

DIGITAL_OUT0=`gpiofind "PA.04"`
DIGITAL_OUT1=`gpiofind "PA.05"`
DIGITAL_OUT2=`gpiofind "PA.06"`
DIGITAL_OUT3=`gpiofind "PA.07"`

echo "DIGITAL_OUT0 OFF"
run_gpioset_out $DIGITAL_OUT0 0
echo "DIGITAL_OUT1 OFF"
run_gpioset_out $DIGITAL_OUT1 0
echo "DIGITAL_OUT2 OFF"
run_gpioset_out $DIGITAL_OUT2 0
echo "DIGITAL_OUT3 OFF"
run_gpioset_out $DIGITAL_OUT3 0

#Single Test
echo "step: 1/15"
echo "DIGITAL_OUT0 ON"
run_gpioset_out $DIGITAL_OUT0 1
sleep $sleep_time
echo "DIGITAL_OUT0 OFF"
run_gpioset_out $DIGITAL_OUT0 0
sleep $sleep_time

echo "step: 2/15"
echo "DIGITAL_OUT1 ON"
run_gpioset_out $DIGITAL_OUT1 1
sleep $sleep_time
echo "DIGITAL_OUT1 OFF"
run_gpioset_out $DIGITAL_OUT1 0
sleep $sleep_time

echo "step: 3/15"
echo "DIGITAL_OUT2 ON"
run_gpioset_out $DIGITAL_OUT2 1
sleep $sleep_time
echo "DIGITAL_OUT2 OFF"
run_gpioset_out $DIGITAL_OUT2 0
sleep $sleep_time

echo "step: 4/15"
echo "DIGITAL_OUT3 ON"
run_gpioset_out $DIGITAL_OUT3 1
sleep $sleep_time
echo "DIGITAL_OUT3 OFF"
run_gpioset_out $DIGITAL_OUT3 0
sleep $sleep_time

#Double Test
echo "step: 5/15"
echo "DIGITAL_OUT0 ON"
echo "DIGITAL_OUT1 ON"
run_gpioset_out $DIGITAL_OUT0 1
run_gpioset_out $DIGITAL_OUT1 1
sleep $sleep_time
echo "DIGITAL_OUT0 OFF"
echo "DIGITAL_OUT1 OFF"
run_gpioset_out $DIGITAL_OUT0 0
run_gpioset_out $DIGITAL_OUT1 0
sleep $sleep_time

echo "step: 6/15"
echo "DIGITAL_OUT0 ON"
echo "DIGITAL_OUT2 ON"
run_gpioset_out $DIGITAL_OUT0 1
run_gpioset_out $DIGITAL_OUT2 1
sleep $sleep_time
echo "DIGITAL_OUT0 OFF"
echo "DIGITAL_OUT2 OFF"
run_gpioset_out $DIGITAL_OUT0 0
run_gpioset_out $DIGITAL_OUT2 0
sleep $sleep_time

echo "step: 7/15"
echo "DIGITAL_OUT0 ON"
echo "DIGITAL_OUT3 ON"
run_gpioset_out $DIGITAL_OUT0 1
run_gpioset_out $DIGITAL_OUT3 1
sleep $sleep_time
echo "DIGITAL_OUT0 OFF"
echo "DIGITAL_OUT3 OFF"
run_gpioset_out $DIGITAL_OUT0 0
run_gpioset_out $DIGITAL_OUT3 0
sleep $sleep_time

echo "step: 8/15"
echo "DIGITAL_OUT1 ON"
echo "DIGITAL_OUT2 ON"
run_gpioset_out $DIGITAL_OUT1 1
run_gpioset_out $DIGITAL_OUT2 1
sleep $sleep_time
echo "DIGITAL_OUT1 OFF"
echo "DIGITAL_OUT2 OFF"
run_gpioset_out $DIGITAL_OUT1 0
run_gpioset_out $DIGITAL_OUT2 0
sleep $sleep_time

echo "step: 9/15"
echo "DIGITAL_OUT1 ON"
echo "DIGITAL_OUT3 ON"
run_gpioset_out $DIGITAL_OUT1 1
run_gpioset_out $DIGITAL_OUT3 1
sleep $sleep_time
echo "DIGITAL_OUT1 OFF"
echo "DIGITAL_OUT3 OFF"
run_gpioset_out $DIGITAL_OUT1 0
run_gpioset_out $DIGITAL_OUT3 0
sleep $sleep_time

echo "step: 10/15"
echo "DIGITAL_OUT2 ON"
echo "DIGITAL_OUT3 ON"
run_gpioset_out $DIGITAL_OUT2 1
run_gpioset_out $DIGITAL_OUT3 1
sleep $sleep_time
echo "DIGITAL_OUT2 OFF"
echo "DIGITAL_OUT3 OFF"
run_gpioset_out $DIGITAL_OUT2 0
run_gpioset_out $DIGITAL_OUT3 0
sleep $sleep_time

#Triple Test
echo "step: 11/15"
echo "DIGITAL_OUT0 ON"
echo "DIGITAL_OUT1 ON"
echo "DIGITAL_OUT2 ON"
run_gpioset_out $DIGITAL_OUT0 1
run_gpioset_out $DIGITAL_OUT1 1
run_gpioset_out $DIGITAL_OUT2 1
sleep $sleep_time
echo "DIGITAL_OUT0 OFF"
echo "DIGITAL_OUT1 OFF"
echo "DIGITAL_OUT2 OFF"
run_gpioset_out $DIGITAL_OUT0 0
run_gpioset_out $DIGITAL_OUT1 0
run_gpioset_out $DIGITAL_OUT2 0
sleep $sleep_time

echo "step: 12/15"
echo "DIGITAL_OUT0 ON"
echo "DIGITAL_OUT1 ON"
echo "DIGITAL_OUT3 ON"
run_gpioset_out $DIGITAL_OUT0 1
run_gpioset_out $DIGITAL_OUT1 1
run_gpioset_out $DIGITAL_OUT3 1
sleep $sleep_time
echo "DIGITAL_OUT0 OFF"
echo "DIGITAL_OUT1 OFF"
echo "DIGITAL_OUT3 OFF"
run_gpioset_out $DIGITAL_OUT0 0
run_gpioset_out $DIGITAL_OUT1 0
run_gpioset_out $DIGITAL_OUT3 0
sleep $sleep_time

echo "step: 13/15"
echo "DIGITAL_OUT0 ON"
echo "DIGITAL_OUT2 ON"
echo "DIGITAL_OUT3 ON"
run_gpioset_out $DIGITAL_OUT0 1
run_gpioset_out $DIGITAL_OUT2 1
run_gpioset_out $DIGITAL_OUT3 1
sleep $sleep_time
echo "DIGITAL_OUT0 OFF"
echo "DIGITAL_OUT2 OFF"
echo "DIGITAL_OUT3 OFF"
run_gpioset_out $DIGITAL_OUT0 0
run_gpioset_out $DIGITAL_OUT2 0
run_gpioset_out $DIGITAL_OUT3 0
sleep $sleep_time

echo "step: 14/15"
echo "DIGITAL_OUT1 ON"
echo "DIGITAL_OUT2 ON"
echo "DIGITAL_OUT3 ON"
run_gpioset_out $DIGITAL_OUT1 1
run_gpioset_out $DIGITAL_OUT2 1
run_gpioset_out $DIGITAL_OUT3 1
sleep $sleep_time
echo "DIGITAL_OUT1 OFF"
echo "DIGITAL_OUT2 OFF"
echo "DIGITAL_OUT3 OFF"
run_gpioset_out $DIGITAL_OUT1 0
run_gpioset_out $DIGITAL_OUT2 0
run_gpioset_out $DIGITAL_OUT3 0
sleep $sleep_time

#Quadruple
echo "step: 15/15"
echo "DIGITAL_OUT0 ON"
echo "DIGITAL_OUT1 ON"
echo "DIGITAL_OUT2 ON"
echo "DIGITAL_OUT3 ON"
run_gpioset_out $DIGITAL_OUT0 1
run_gpioset_out $DIGITAL_OUT1 1
run_gpioset_out $DIGITAL_OUT2 1
run_gpioset_out $DIGITAL_OUT3 1
sleep $sleep_time
echo "DIGITAL_OUT0 OFF"
echo "DIGITAL_OUT1 OFF"
echo "DIGITAL_OUT2 OFF"
echo "DIGITAL_OUT3 OFF"
run_gpioset_out $DIGITAL_OUT0 0
run_gpioset_out $DIGITAL_OUT1 0
run_gpioset_out $DIGITAL_OUT2 0
run_gpioset_out $DIGITAL_OUT3 0
sleep $sleep_time

echo "Completed"

sleep 1
run_gpioset_out $DIGITAL_OUT0 1
run_gpioset_out $DIGITAL_OUT1 1
run_gpioset_out $DIGITAL_OUT2 1
run_gpioset_out $DIGITAL_OUT3 1
sleep 1

