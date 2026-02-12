#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	echo "Quitting ..."
	exit 1
fi

# Check the scipts' folder
SCRIPTS_FOLDER=${PWD}
if [ $# -eq 1 ]; then
	SCRIPTS_FOLDER=$1
fi
if [ $# -gt 1 ]; then
	echo "Please type test scripts' folder path"
	echo "Please run as:"
	echo "sudo $0 <test_scripts'_full_path>"
	echo "Quitting ..."
	exit 1
fi
if [ -d "$SCRIPTS_FOLDER" ]; then
	if [ "${SCRIPTS_FOLDER: -1}" != "/" ]; then
		SCRIPTS_FOLDER="$SCRIPTS_FOLDER/"
	fi
	echo "$SCRIPTS_FOLDER folder exists"
	chmod +x $SCRIPTS_FOLDER/iperf3_*.sh
	chmod +x $SCRIPTS_FOLDER/test_*.sh
	echo "All script files made executable"
else
	echo "$SCRIPTS_FOLDER folder does not exist"
	echo "Quitting ..."
	exit 1
fi

function apt_install_pkg {
	REQUIRED_PKG=$1
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
	echo "Checking for $REQUIRED_PKG: $PKG_OK"
	if [ "" = "$PKG_OK" ]; then
		echo ""
		echo "$REQUIRED_PKG not found. Setting it up..."
		sudo apt-get --yes install $REQUIRED_PKG 

		PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
		echo ""
		echo "Checking for $REQUIRED_PKG: $PKG_OK"

		if [ "" = "$PKG_OK" ]; then
			echo ""
			echo "$REQUIRED_PKG not installed. Please try again later"
			exit 1
		fi

	fi
}

# Check GtkTerm installed
apt_install_pkg 'gtkterm'

# Check gpiod installed
apt_install_pkg 'gpiod'

# Check nvidia-l4t-gstreamer installed for CSI tests
apt_install_pkg 'nvidia-l4t-gstreamer'


function check_nvgetty_service {
	echo -n "nvgetty.service status: "
	if [ "$(systemctl is-enabled nvgetty.service)" = "enabled" ]; then
		echo "enabled"
		sleep 2
		sudo systemctl disable nvgetty.service
		echo "Service disabled, rebooting now ..."
		sleep 10
		sudo reboot
	elif [ "$(systemctl is-enabled nvgetty.service)" = "disabled" ]; then
		echo "disabled"
	else
		echo "Failed to get unit file state -> No such file or directory"
		echo "Skipping..."
	fi
}


function test_menu {
	continue_test=true

	while $continue_test; do
		sleep 1
		echo ""
		echo "****************************"
		echo "*** Production Test Menu ***"
		echo "1) Previous Tests"
		echo "2) Disks (M.2 SSD) Test"
		echo "3) Network Speed Test"
		echo "4) Local Network Test (iperf3)"
		echo "5) Public Network Test (ping)"
		echo "6) USB Test"
		echo "7) M.2 Key-E Test"
		echo "8) M.2 Key-B Test"
		echo "9) RS-232_0 Test"
		echo "10) RS-422_0 Test"
		echo "11) RS-485_0 Write Test"
		echo "12) RS-485_0 Read Test"
		echo "13) RS-232_1 Test"
		echo "14) RS-422_1 Test"
		echo "15) RS-485_1 Write Test"
		echo "16) RS-485_1 Read Test"
		echo "17) CAN Bus-0 (Transmit) Test"
		echo "18) CAN Bus-0 (Receive) Test"
		echo "19) CAN Bus-1 (Transmit) Test"
		echo "20) CAN Bus-1 (Receive) Test"
		echo "21) Digital Out Test"
		echo "22) Digital In-0 Test"
		echo "23) Digital In-1 Test"
		echo "24) Digital In-2 Test"
		echo "25) Digital In-3 Test"
		echo "26) Temperature Sensor Test"
		echo "27) Accelerometer Test"
		echo "28) Fan Test"
		read -p "Type the test number (or quit) [1/.../q]: " choice
		echo ""

		case $choice in
			1 )
				echo "* Set the device in recovery mode, connect recovery USB and check the device in recovery mode with lsusb"
				echo "*     0955:7323 for Orin NX 16GB"
				echo "*     0955:7423 for Orin NX 8GB"
				echo "*     0955:7523 for Orin Nano 8GB"
				echo "*     0955:7623 for Orin Nano 4GB"
				echo "* Reset the device, connect Debug port and check the serial connection"
				;;
			2 )
				echo "Check M.2 SSD detected"
				gnome-terminal -- gnome-disks
				;;
			3 )
				echo "Network Speed Test"
				gnome-terminal -- $SCRIPTS_FOLDER/test_net_speed.sh
				;;
			4 )
				echo "Local Network Test"
				read -p "Server or Client (s/c): " network_choice
				case $network_choice in
					[Ss]* )
						gnome-terminal -- $SCRIPTS_FOLDER/iperf3_server.sh
						;;
					[Cc]* )
						gnome-terminal -- $SCRIPTS_FOLDER/iperf3_client.sh
						;;
					* )
						echo "Wrong choice"
						;;
				esac
				;;
			5 )
				echo "Public Network Test"
				gnome-terminal -- $SCRIPTS_FOLDER/test_public_net.sh
				;;
			6 )
				echo "USB Test"
				gnome-terminal -- watch -n 0.1 lsusb
				;;
			7 )
				echo "M.2 Key-E Test"
				gnome-terminal -- $SCRIPTS_FOLDER/test_key_e_orin.sh
				gnome-terminal -- watch -n 0.1 lspci
				;;
			8 )
				echo "M.2 Key-B Test"
				gnome-terminal -- $SCRIPTS_FOLDER/test_key_b_orin.sh
				;;
			9 )
				echo "RS232_0 Test"
				check_nvgetty_service
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_ch0_rs232_orin.sh $board_rev_1_2
				;;
			10 )
				echo "RS422_0 Test"
				check_nvgetty_service
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_ch0_rs422_orin.sh $board_rev_1_2
				;;
			11 )
				echo "RS485_0 Write Test"
				check_nvgetty_service
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_ch0_rs485_write_orin.sh $board_rev_1_2
				;;
			12 )
				echo "RS485_0 Read Test"
				check_nvgetty_service
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_ch0_rs485_read_orin.sh $board_rev_1_2
				;;
			13 )
				echo "RS232_1 Test"
				check_nvgetty_service
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_ch1_rs232_orin.sh $board_rev_1_2
				;;
			14 )
				echo "RS422_1 Test"
				check_nvgetty_service
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_ch1_rs422_orin.sh $board_rev_1_2
				;;
			15 )
				echo "RS485_1 Write Test"
				check_nvgetty_service
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_ch1_rs485_write_orin.sh $board_rev_1_2
				;;
			16 )
				echo "RS485_1 Read Test"
				check_nvgetty_service
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_ch1_rs485_read_orin.sh $board_rev_1_2
				;;
			17 )
				echo "CAN Bus-0 (Transmit) Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_can0_transmit_orin.sh
				;;
			18 )
				echo "CAN Bus-0 (Receive) Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_can0_receive_orin.sh
				;;
			19 )
				echo "CAN Bus-1 (Transmit) Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_can1_transmit_orin.sh
				;;
			20 )
				echo "CAN Bus-1 (Receive) Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_can1_receive_orin.sh
				;;
			21 )
				echo "Digital Out Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_digital_out_multi_orin.sh
				;;
			22 )
				echo "Digital In-0 Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_digital_in0_orin.sh
				;;
			23 )
				echo "Digital In-1 Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_digital_in1_orin.sh
				;;
			24 )
				echo "Digital In-2 Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_digital_in2_orin.sh
				;;
			25 )
				echo "Digital In-3 Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_digital_in3_orin.sh
				;;
			26 )
				echo "Temperature Sensor Test"
				if [ -d "/sys/bus/i2c/devices/0-0049" ]; then
					gnome-terminal -- watch -n 0.1 cat /sys/bus/i2c/devices/0-0049/hwmon/hwmon*/temp1_input
				else
					echo "Temperature Sensor could not found"
				fi
				;;
			27 )
				echo "Accelerometer Test"
				if [ -d "/sys/bus/i2c/devices/7-0068" ]; then
					gnome-terminal -- watch -n 0.1 cat /sys/bus/i2c/devices/7-0068/iio\:device0/in_*
				else
					echo "Accelerometer could not found"
				fi
				;;
			28 )
				echo "Fan Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_fan.sh
				;;
			[Qq]* )
				echo "Quitting ..."
				exit 1
				;;
			* )
				echo "Wrong choice"
				;;
		esac
	done
}


test_menu

