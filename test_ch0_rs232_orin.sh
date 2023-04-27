#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

sudo echo 471 > /sys/class/gpio/export
sudo echo 470 > /sys/class/gpio/export

sudo echo low > /sys/class/gpio/PY.01/direction
sudo echo low > /sys/class/gpio/PY.00/direction

sudo gtkterm -p /dev/ttyTHS1 -s 115200

sudo echo 471 > /sys/class/gpio/unexport
sudo echo 470 > /sys/class/gpio/unexport

