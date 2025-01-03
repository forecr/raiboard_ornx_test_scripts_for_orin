#!/usr/bin/env python3 
from smbus2 import SMBus, i2c_msg
import numpy as np
import matplotlib.pyplot as plt
import time
import sys
import os

# MPU6050 I2C address
SLAVE_ADDR = 0x68

# MPU6050 register addresses
PWR_MGMT_1 = 0x6B
PWR_MGMT_2 = 0x6C

# Gyroscope and Accelerometer register addresses
GYRO_X = 0x43
GYRO_Y = 0x45
GYRO_Z = 0x47

ACCL_X = 0x3B
ACCL_Y = 0x3D
ACCL_Z = 0x3F

# I2C bus object definition
bus = SMBus(7)  # Select the correct bus number
bus.write_byte_data(SLAVE_ADDR, PWR_MGMT_1, 0)
bus.write_byte_data(SLAVE_ADDR, PWR_MGMT_2, 0)

# Global variable
previous_time = time.time()

def read_word_i2c(register):
    """Read two bytes and return as unsigned integer."""
    try:
        msg = i2c_msg.read(SLAVE_ADDR, 2)  # create msg to store 2 byte data
        bus.i2c_rdwr(i2c_msg.write(SLAVE_ADDR, [register]), msg)  # Communicate with register address and msg

        # Read the bytes and merge them
        data = np.array(list(msg), dtype=np.uint8)  # change data to numpy array
        val = (data[0] << 8) + data[1]  # merge two bytes
        # Convert negative values
        if val >= 0x8000:
            val -= 0x10000

        return val
    except Exception as e:
        print(f"Error reading from I2C: {e}")
        return 0

def read_gyro():
    """Read Gyroscope data and return."""
    gyro_x = read_word_i2c(GYRO_X)
    gyro_y = read_word_i2c(GYRO_Y)
    gyro_z = read_word_i2c(GYRO_Z)

    return {'x': gyro_x / 131.0, 'y': gyro_y / 131.0, 'z': gyro_z / 131.0}

def read_accel():
    """Read Accelerometer data and return."""
    accel_x = read_word_i2c(ACCL_X)
    accel_y = read_word_i2c(ACCL_Y)
    accel_z = read_word_i2c(ACCL_Z)

    calc_accel = np.array([accel_x, accel_y, accel_z], dtype=np.float32) / 16384.0
    return {'x': calc_accel[0], 'y': calc_accel[1], 'z': calc_accel[2]}

def calculate_roll_pitch():
    """Calculate roll ve pitch angles."""
    accel = read_accel()
    accel_x = accel['x']
    accel_y = accel['y']
    accel_z = accel['z']

    roll = np.degrees(np.arctan2(accel_y, np.sqrt(accel_x ** 2 + accel_z ** 2)))
    pitch = np.degrees(np.arctan2(-accel_x, np.sqrt(accel_y ** 2 + accel_z ** 2)))

    return {'roll': roll, 'pitch': pitch}

def complement_filter(accel_data, gyro_data, alpha=0.98):
    """Calculate roll ve pitch angles with complementer filter."""
    global previous_time  # Define global variable
    roll_pitch_accel = calculate_roll_pitch()
    roll_accel = roll_pitch_accel['roll']
    pitch_accel = roll_pitch_accel['pitch']

    dt = time.time() - previous_time
    roll_gyro = roll_accel + gyro_data['x'] * dt
    pitch_gyro = pitch_accel + (gyro_data['y'] * dt)

    roll = alpha * roll_gyro + (1 - alpha) * accel_data['x']
    pitch = alpha * pitch_gyro + (1 - alpha) * accel_data['y']

    previous_time = time.time()

    return {'roll': roll, 'pitch': pitch}

def main():
    fig = plt.figure(figsize=(10, 12), num='Roll and Pitch Angles')  
    ax = fig.add_subplot(1, 1, 1)

    # Title
    ax.set_title('Roll and Pitch Angles (Filtered)')

    # Axis settings
    ax.set_xlim(0, 60)  # Extend X-axis to 60 seconds
    ax.set_ylim(-180, 180)

    time_data = []
    roll_data = []
    pitch_data = []
    roll_accel_data = []
    pitch_accel_data = []

    start_time = time.time()
    try:
        while True:
            # Read data
            current_time = time.time() - start_time
            time_data.append(current_time)

            accel_data = read_accel()
            gyro_data = read_gyro()
            roll_pitch = complement_filter(accel_data, gyro_data)
            roll_accel = calculate_roll_pitch()['roll']
            pitch_accel = calculate_roll_pitch()['pitch']

            # Add data to list
            roll_data.append(roll_pitch['roll'])
            pitch_data.append(roll_pitch['pitch'])
            roll_accel_data.append(roll_accel)
            pitch_accel_data.append(pitch_accel)

            # Draw graphic
            ax.cla()  # Clear axis
            ax.set_title('Roll and Pitch Angles (Filtered)')  # Set title
            ax.plot(time_data[-60:], roll_data[-60:], label='Roll (Filtered)', color='b')
            ax.plot(time_data[-60:], pitch_data[-60:], label='Pitch (Filtered)', color='r')
            ax.grid(True, which='both', linestyle='--', linewidth=0.7)
            ax.legend(loc='upper right')
  
            plt.draw()
            plt.pause(0.1)  # Preferred update time
            os.system('clear')
            print(f"Roll: {roll_pitch['roll']:.2f}")
            print(f"Pitch: {roll_pitch['pitch']:.2f}")
            

    except KeyboardInterrupt:
        sys.exit(0)

if __name__ == "__main__":
    main()


