#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

#gpioset --mode=signal `gpiofind "PR.04"`=0 &
#PID_M2E_W_DISABLE2=$!
#gpioset --mode=signal `gpiofind "PH.00"`=0 &
#PID_M2E_W_DISABLE1=$!
gpioset --mode=signal `gpiofind "PAC.06"`=1 &
PID_USB_MUX_SELECT=$!

trap interrupt_func INT
interrupt_func() {
	#kill $PID_M2E_W_DISABLE2
	#kill $PID_M2E_W_DISABLE1
	kill $PID_USB_MUX_SELECT
}

watch -n 0.1 lsusb

