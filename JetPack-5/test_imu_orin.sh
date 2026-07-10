#!/bin/bash

# Path to the IIO device
IIO_DIR="/sys/bus/i2c/devices/7-0068/iio:device0"

# Check if path exists
if [ ! -d "$IIO_DIR" ]; then
    echo "Error: IIO device directory not found at $IIO_DIR"
    exit 1
fi

# Fetch Scales and Offsets
ACCEL_SCALE=$(cat "$IIO_DIR/in_accel_scale")
GYRO_SCALE=$(cat "$IIO_DIR/in_anglvel_scale")
TEMP_SCALE=$(cat "$IIO_DIR/in_temp_scale")
TEMP_OFFSET=$(cat "$IIO_DIR/in_temp_offset")

echo "--- IAM-20680HT Real-Time Data ---"

while true; do
    # 1. Read Raw Values
    ax_raw=$(cat "$IIO_DIR/in_accel_x_raw")
    ay_raw=$(cat "$IIO_DIR/in_accel_y_raw")
    az_raw=$(cat "$IIO_DIR/in_accel_z_raw")
    
    gx_raw=$(cat "$IIO_DIR/in_anglvel_x_raw")
    gy_raw=$(cat "$IIO_DIR/in_anglvel_y_raw")
    gz_raw=$(cat "$IIO_DIR/in_anglvel_z_raw")
    
    t_raw=$(cat "$IIO_DIR/in_temp_raw")

    # 2. Compute Physical Values using bc
    ax=$(echo "$ax_raw * $ACCEL_SCALE" | bc -l)
    ay=$(echo "$ay_raw * $ACCEL_SCALE" | bc -l)
    az=$(echo "$az_raw * $ACCEL_SCALE" | bc -l)

    gx=$(echo "$gx_raw * $GYRO_SCALE" | bc -l)
    gy=$(echo "$gy_raw * $GYRO_SCALE" | bc -l)
    gz=$(echo "$gz_raw * $GYRO_SCALE" | bc -l)

    # Temp formula: (Raw + Offset) * Scale / 1000 to get Celsius 
    # (or directly if driver already factored the 1000 into scale)
    temp=$(echo "($t_raw + $TEMP_OFFSET) * $TEMP_SCALE / 1000" | bc -l)

    # 3. Print out clean results (Formatted to 3 decimal places)
    clear
    echo "--- IAM-20680HT Live Telemetry (Ctrl+C to exit) ---"
    printf "Accelerometer (m/s²):  X: %7.3f  |  Y: %7.3f  |  Z: %7.3f\n" "$ax" "$ay" "$az"
    printf "Gyroscope (rad/s):     X: %7.3f  |  Y: %7.3f  |  Z: %7.3f\n" "$gx" "$gy" "$gz"
    printf "Temperature (°C):      %6.2f °C\n" "$temp"
    
    sleep 0.1
done
