#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

sleep_time=0.3

sudo echo 352 > /sys/class/gpio/export
sudo echo out > /sys/class/gpio/PA.04/direction
sudo echo 353 > /sys/class/gpio/export
sudo echo out > /sys/class/gpio/PA.05/direction
sudo echo 354 > /sys/class/gpio/export
sudo echo out > /sys/class/gpio/PA.06/direction
sudo echo 355 > /sys/class/gpio/export
sudo echo out > /sys/class/gpio/PA.07/direction

sleep $sleep_time

echo "DIGITAL_OUT0 OFF"
sudo echo 0 > /sys/class/gpio/PA.04/value
echo "DIGITAL_OUT1 OFF"
sudo echo 0 > /sys/class/gpio/PA.05/value
echo "DIGITAL_OUT2 OFF"
sudo echo 0 > /sys/class/gpio/PA.06/value
echo "DIGITAL_OUT3 OFF"
sudo echo 0 > /sys/class/gpio/PA.07/value

#Single Test
echo "step: 1/15"
echo "DIGITAL_OUT0 ON"
sudo echo 1 > /sys/class/gpio/PA.04/value
sleep $sleep_time
echo "DIGITAL_OUT0 OFF"
sudo echo 0 > /sys/class/gpio/PA.04/value
sleep $sleep_time

echo "step: 2/15"
echo "DIGITAL_OUT1 ON"
sudo echo 1 > /sys/class/gpio/PA.05/value
sleep $sleep_time
echo "DIGITAL_OUT1 OFF"
sudo echo 0 > /sys/class/gpio/PA.05/value
sleep $sleep_time

echo "step: 3/15"
echo "DIGITAL_OUT2 ON"
sudo echo 1 > /sys/class/gpio/PA.06/value
sleep $sleep_time
echo "DIGITAL_OUT2 OFF"
sudo echo 0 > /sys/class/gpio/PA.06/value
sleep $sleep_time

echo "step: 4/15"
echo "DIGITAL_OUT3 ON"
sudo echo 1 > /sys/class/gpio/PA.07/value
sleep $sleep_time
echo "DIGITAL_OUT3 OFF"
sudo echo 0 > /sys/class/gpio/PA.07/value
sleep $sleep_time

#Double Test
echo "step: 5/15"
echo "DIGITAL_OUT0 ON"
echo "DIGITAL_OUT1 ON"
sudo echo 1 > /sys/class/gpio/PA.04/value
sudo echo 1 > /sys/class/gpio/PA.05/value
sleep $sleep_time
echo "DIGITAL_OUT0 OFF"
echo "DIGITAL_OUT1 OFF"
sudo echo 0 > /sys/class/gpio/PA.04/value
sudo echo 0 > /sys/class/gpio/PA.05/value
sleep $sleep_time

echo "step: 6/15"
echo "DIGITAL_OUT0 ON"
echo "DIGITAL_OUT2 ON"
sudo echo 1 > /sys/class/gpio/PA.04/value
sudo echo 1 > /sys/class/gpio/PA.06/value
sleep $sleep_time
echo "DIGITAL_OUT0 OFF"
echo "DIGITAL_OUT2 OFF"
sudo echo 0 > /sys/class/gpio/PA.04/value
sudo echo 0 > /sys/class/gpio/PA.06/value
sleep $sleep_time

echo "step: 7/15"
echo "DIGITAL_OUT0 ON"
echo "DIGITAL_OUT3 ON"
sudo echo 1 > /sys/class/gpio/PA.04/value
sudo echo 1 > /sys/class/gpio/PA.07/value
sleep $sleep_time
echo "DIGITAL_OUT0 OFF"
echo "DIGITAL_OUT3 OFF"
sudo echo 0 > /sys/class/gpio/PA.04/value
sudo echo 0 > /sys/class/gpio/PA.07/value
sleep $sleep_time

echo "step: 8/15"
echo "DIGITAL_OUT1 ON"
echo "DIGITAL_OUT2 ON"
sudo echo 1 > /sys/class/gpio/PA.05/value
sudo echo 1 > /sys/class/gpio/PA.06/value
sleep $sleep_time
echo "DIGITAL_OUT1 OFF"
echo "DIGITAL_OUT2 OFF"
sudo echo 0 > /sys/class/gpio/PA.05/value
sudo echo 0 > /sys/class/gpio/PA.06/value
sleep $sleep_time

echo "step: 9/15"
echo "DIGITAL_OUT1 ON"
echo "DIGITAL_OUT3 ON"
sudo echo 1 > /sys/class/gpio/PA.05/value
sudo echo 1 > /sys/class/gpio/PA.07/value
sleep $sleep_time
echo "DIGITAL_OUT1 OFF"
echo "DIGITAL_OUT3 OFF"
sudo echo 0 > /sys/class/gpio/PA.05/value
sudo echo 0 > /sys/class/gpio/PA.07/value
sleep $sleep_time

echo "step: 10/15"
echo "DIGITAL_OUT2 ON"
echo "DIGITAL_OUT3 ON"
sudo echo 1 > /sys/class/gpio/PA.06/value
sudo echo 1 > /sys/class/gpio/PA.07/value
sleep $sleep_time
echo "DIGITAL_OUT2 OFF"
echo "DIGITAL_OUT3 OFF"
sudo echo 0 > /sys/class/gpio/PA.06/value
sudo echo 0 > /sys/class/gpio/PA.07/value
sleep $sleep_time

#Triple Test
echo "step: 11/15"
echo "DIGITAL_OUT0 ON"
echo "DIGITAL_OUT1 ON"
echo "DIGITAL_OUT2 ON"
sudo echo 1 > /sys/class/gpio/PA.04/value
sudo echo 1 > /sys/class/gpio/PA.05/value
sudo echo 1 > /sys/class/gpio/PA.06/value
sleep $sleep_time
echo "DIGITAL_OUT0 OFF"
echo "DIGITAL_OUT1 OFF"
echo "DIGITAL_OUT2 OFF"
sudo echo 0 > /sys/class/gpio/PA.04/value
sudo echo 0 > /sys/class/gpio/PA.05/value
sudo echo 0 > /sys/class/gpio/PA.06/value
sleep $sleep_time

echo "step: 12/15"
echo "DIGITAL_OUT0 ON"
echo "DIGITAL_OUT1 ON"
echo "DIGITAL_OUT3 ON"
sudo echo 1 > /sys/class/gpio/PA.04/value
sudo echo 1 > /sys/class/gpio/PA.05/value
sudo echo 1 > /sys/class/gpio/PA.07/value
sleep $sleep_time
echo "DIGITAL_OUT0 OFF"
echo "DIGITAL_OUT1 OFF"
echo "DIGITAL_OUT3 OFF"
sudo echo 0 > /sys/class/gpio/PA.04/value
sudo echo 0 > /sys/class/gpio/PA.05/value
sudo echo 0 > /sys/class/gpio/PA.07/value
sleep $sleep_time

echo "step: 13/15"
echo "DIGITAL_OUT0 ON"
echo "DIGITAL_OUT2 ON"
echo "DIGITAL_OUT3 ON"
sudo echo 1 > /sys/class/gpio/PA.04/value
sudo echo 1 > /sys/class/gpio/PA.06/value
sudo echo 1 > /sys/class/gpio/PA.07/value
sleep $sleep_time
echo "DIGITAL_OUT0 OFF"
echo "DIGITAL_OUT2 OFF"
echo "DIGITAL_OUT3 OFF"
sudo echo 0 > /sys/class/gpio/PA.04/value
sudo echo 0 > /sys/class/gpio/PA.06/value
sudo echo 0 > /sys/class/gpio/PA.07/value
sleep $sleep_time

echo "step: 14/15"
echo "DIGITAL_OUT1 ON"
echo "DIGITAL_OUT2 ON"
echo "DIGITAL_OUT3 ON"
sudo echo 1 > /sys/class/gpio/PA.05/value
sudo echo 1 > /sys/class/gpio/PA.06/value
sudo echo 1 > /sys/class/gpio/PA.07/value
sleep $sleep_time
echo "DIGITAL_OUT1 OFF"
echo "DIGITAL_OUT2 OFF"
echo "DIGITAL_OUT3 OFF"
sudo echo 0 > /sys/class/gpio/PA.05/value
sudo echo 0 > /sys/class/gpio/PA.06/value
sudo echo 0 > /sys/class/gpio/PA.07/value
sleep $sleep_time

#Quadruple
echo "step: 15/15"
echo "DIGITAL_OUT0 ON"
echo "DIGITAL_OUT1 ON"
echo "DIGITAL_OUT2 ON"
echo "DIGITAL_OUT3 ON"
sudo echo 1 > /sys/class/gpio/PA.04/value
sudo echo 1 > /sys/class/gpio/PA.05/value
sudo echo 1 > /sys/class/gpio/PA.06/value
sudo echo 1 > /sys/class/gpio/PA.07/value
sleep $sleep_time
echo "DIGITAL_OUT0 OFF"
echo "DIGITAL_OUT1 OFF"
echo "DIGITAL_OUT2 OFF"
echo "DIGITAL_OUT3 OFF"
sudo echo 0 > /sys/class/gpio/PA.04/value
sudo echo 0 > /sys/class/gpio/PA.05/value
sudo echo 0 > /sys/class/gpio/PA.06/value
sudo echo 0 > /sys/class/gpio/PA.07/value
sleep $sleep_time


echo "Completed"

sleep 1
sudo echo 1 > /sys/class/gpio/PA.04/value
sudo echo 1 > /sys/class/gpio/PA.05/value
sudo echo 1 > /sys/class/gpio/PA.06/value
sudo echo 1 > /sys/class/gpio/PA.07/value
sleep 1

sudo echo 352 > /sys/class/gpio/unexport
sudo echo 353 > /sys/class/gpio/unexport
sudo echo 354 > /sys/class/gpio/unexport
sudo echo 355 > /sys/class/gpio/unexport

