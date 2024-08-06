#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

sudo echo 474 > /sys/class/gpio/export
sudo echo 473 > /sys/class/gpio/export
sudo echo 472 > /sys/class/gpio/export
sudo echo 469 > /sys/class/gpio/export

sudo echo high > /sys/class/gpio/PY.04/direction
sudo echo low > /sys/class/gpio/PY.03/direction
sudo echo high > /sys/class/gpio/PY.02/direction
sudo echo low > /sys/class/gpio/PX.07/direction

sudo gtkterm -p /dev/ttyTHS0 -s 115200

sudo echo 474 > /sys/class/gpio/unexport
sudo echo 473 > /sys/class/gpio/unexport
sudo echo 472 > /sys/class/gpio/unexport
sudo echo 469 > /sys/class/gpio/unexport

