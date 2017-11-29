ARDUINO_BAUDS=57600
# ARDUINO_BAUDS=115200

rosrun rosserial_python serial_node.py \
		_port:=/dev/ttyACM0		\
		_baud:=$ARDUINO_BAUDS
