#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
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

function pip_install_pkg {
	local REQUIRED_PKG=$1
	local PKG_OK

	PKG_OK=$(pip show $REQUIRED_PKG|grep "Name:")

	echo "Checking for $REQUIRED_PKG: $PKG_OK"

	if [ "" = "$PKG_OK" ]; then
		echo ""
		echo "$REQUIRED_PKG not found. Setting it up..."
		sudo pip install $REQUIRED_PKG

		PKG_OK=$(pip show $REQUIRED_PKG|grep "Name:")
		echo ""
		echo "Checking for $REQUIRED_PKG: $PKG_OK"

		if [ "" = "$PKG_OK" ]; then
			echo ""
			echo "$REQUIRED_PKG not installed. Please try again later"
			exit 1
		fi
	fi
}

# Check if the packages are installed
apt_install_pkg 'python3-pip'
apt_install_pkg 'python3'

pip_install_pkg 'numpy'
pip_install_pkg 'smbus2'
pip_install_pkg 'matplotlib'


chmod +x $PWD/test_mpu6050_pitch_roll_angle.py

if [ -d "/sys/bus/i2c/devices/7-0068" ]; then
	OUTPUT=$(sudo i2cdetect -y -r 7)
	if echo "$OUTPUT" | grep -q "UU"; then
		echo "7-0068" | sudo tee /sys/bus/i2c/drivers/inv-mpu6050-i2c/unbind
		echo "unbind"
		gnome-terminal -- sudo "$PWD/test_mpu6050_pitch_roll_angle.py"
		sleep 5
		echo "7-0068" | sudo tee /sys/bus/i2c/drivers/inv-mpu6050-i2c/bind
		echo "bind"

	else
		gnome-terminal -- sudo "$PWD/test_mpu6050_pitch_roll_angle.py"
	fi
else
	echo "Accelerometer could not found"
fi

