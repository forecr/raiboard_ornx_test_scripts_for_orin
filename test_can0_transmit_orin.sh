#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

sudo modprobe can
sudo modprobe can_raw
sudo modprobe mttcan
sudo ip link set can0 up type can bitrate 500000 sjw 127 dsjw 15

trap interrupt_func INT
interrupt_func() {
	sudo ip link set can0 down
}

cangen can0 -v

