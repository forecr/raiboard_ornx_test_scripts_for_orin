#sudo echo 460 > /sys/class/gpio/export
#sudo echo 391 > /sys/class/gpio/export
sudo echo 492 > /sys/class/gpio/export # USB_Mux

#sudo echo low > /sys/class/gpio/PR.04/direction
#sudo echo low > /sys/class/gpio/PH.00/direction
sudo echo high > /sys/class/gpio/PAC.06/direction

trap interrupt_func INT
interrupt_func() {
	#sudo echo 460 > /sys/class/gpio/unexport
	#sudo echo 391 > /sys/class/gpio/unexport
	sudo echo 492 > /sys/class/gpio/unexport
}

watch -n 0.1 lsusb

