#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

sudo modprobe can
sudo modprobe can_raw
sudo modprobe mttcan
sudo ip link set can1 up type can bitrate 500000 dbitrate 2000000 berr-reporting on fd on

trap disable_keye INT
disable_keye() {
	sudo ip link set can1 down
}

candump can1

