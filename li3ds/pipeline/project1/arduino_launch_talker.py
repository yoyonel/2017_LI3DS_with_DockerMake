#!/usr/bin/env python
"""arduino_launch_talker

Usage:
  arduino_launch_talker.py  [--rate=N]
                            [--t2=N] [--t3=N] [--t4=N]
                            [--flash_on | --flash_off]
                            [--start_on | --start_off]
                            [--pause_on | --pause_off]
  arduino_launch_talker.py (-h | --help)
  arduino_launch_talker.py --version

Options:
  -h, --help            show help
  --version             show version
  --rate=N              Frequence du message ROS (en Hz)
                        [default: 1.00]
  --t2=<seconds>        Seconds
                        [default: 59]
  --t3=<minutes>        Minutes
                        [default: 59]
  --t4=<hours>          Hours
                        [default: 23]
  --flash_off           LEDs    off
  --flash_on            LEDs    on
  --start_off           Start   off
  --start_on            Start   on
  --pause_off           Pause   off
  --pause_on            Pause   on
"""

from docopt import docopt
try:
    from schema import Schema, And, Or, Use, SchemaError
except ImportError:
    exit('This example requires that `schema` data-validation library'
         ' is installed: \n    pip install schema\n'
         'https://github.com/halst/schema')

import rospy
from sbg_driver.msg import gps


def talker(**kwargs):
    pub = rospy.Publisher('/Arduino/gps', gps, queue_size=2)

    rospy.init_node('custom_talker', anonymous=True)

    # r = rospy.Rate(kwargs.get('--rate', 1))

    msg = gps()
    msg.t2_t3_t4 = [
        kwargs.get('--t2', 59),
        kwargs.get('--t3', 59),
        kwargs.get('--t4', 23)
    ]
    # msg.gprmc_pos = "Message NMEA"

    # # States
    msg.state_flash = kwargs.get('--flash_on', False)
    msg.state_start = kwargs.get('--start_on', False)
    msg.state_pause = kwargs.get('--pause_on', False)

    r = rospy.Rate(kwargs.get("--rate", 1.0))

    while not rospy.is_shutdown():
        rospy.loginfo(msg)
        pub.publish(msg)
        r.sleep()


if __name__ == '__main__':
    args = docopt(
        __doc__,
        version='1.0.0'
    )

    schema = Schema({
        '--help': Or(None, And(Use(bool), lambda n: True)),
        '--version': Or(None, And(Use(bool), lambda n: True)),
        # 'ros': Or(None, And(Use(bool), lambda n: True)),
        # 'clock': Or(None, And(Use(bool), lambda n: True)),
        # 'state': Or(None, And(Use(bool), lambda n: True)),
        '--rate': Or(None, And(Use(float), lambda n: 0.0 <= n < 100.0),
                     error='--rate=N should be float 0.0 <= N <= 100.0'),
        '--t2': Or(None, And(Use(int), lambda n: 0 <= n < 60),
                   error='--t2=N should be integer 0 <= N < 60'),
        '--t3': Or(None, And(Use(int), lambda n: 0 <= n < 60),
                   error='--t3=N should be integer 0 <= N < 60'),
        '--t4': Or(None, And(Use(int), lambda n: 0 <= n < 24),
                   error='--t4=N should be integer 0 <= N < 24'),
        '--flash_on': Or(None, And(Use(bool), lambda n: True)),
        '--flash_off': Or(None, And(Use(bool), lambda n: True)),
        '--start_on': Or(None, And(Use(bool), lambda n: True)),
        '--start_off': Or(None, And(Use(bool), lambda n: True)),
        '--pause_on': Or(None, And(Use(bool), lambda n: True)),
        '--pause_off': Or(None, And(Use(bool), lambda n: True)),
    }
    )
    try:
        args = schema.validate(args)
    except SchemaError as e:
        exit(e)

    print(args)

    try:
        talker(**args)
    except rospy.ROSInterruptException:
        pass
