#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

#gpioset --mode=signal `gpiofind "PQ.06"`=0 &
#PID_M2B_RESET=$!
gpioset --mode=signal `gpiofind "PN.01"`=1 &
PID_M2B_FULLCARD_PWRON=$!
#gpioset --mode=signal `gpiofind "PCC.00"`=1 &
#PID_M2B_W_ENABLE1=$!
gpioset --mode=signal `gpiofind "PCC.03"`=0 &
PID_M2B_PWR_OFF=$!
#gpioset --mode=signal `gpiofind "PP.06"`=1 &
#PID_M2B_W_ENABLE2=$!
gpioset --mode=signal `gpiofind "PAC.06"`=0 &
PID_USB_MUX_SELECT=$!

trap interrupt_func INT
interrupt_func() {
	#kill $PID_M2B_RESET
	kill $PID_M2B_FULLCARD_PWRON
	#kill $PID_M2B_W_ENABLE1
	kill $PID_M2B_PWR_OFF
	#kill $PID_M2B_W_ENABLE2
	kill $PID_USB_MUX_SELECT
}

watch -n 0.1 lsusb

