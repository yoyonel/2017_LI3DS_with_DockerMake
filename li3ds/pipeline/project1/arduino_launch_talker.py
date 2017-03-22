#!/usr/bin/env python
"""arduino_launch_talker

Usage:
  arduino_launch_talker.py  [--rate=N] [--topic=TOPIC]
                            [--gps_time=<d:d:d>]
                            [--flash=<BOOL>]
                            [--start=<BOOL>]
                            [--pause=<BOOL>]
                            [--boot=<BOOL>]
  arduino_launch_talker.py (-h | --help)
  arduino_launch_talker.py --version

Options:
  -h, --help            show help
  --version             show version
  --rate=N              Frequence du message ROS (en Hz)
                        [default: 1.00]
  --topic=TOPIC         Topic name for ROS publisher
                        [default: /Arduino/commands]
  --gps_time=<d:d:d>    GPS time to send
  --flash=BOOL          set LEDs state
  --start=BOOL          set Start state
  --pause=BOOL          set Pause state
  --boot=BOOL           set boot state
"""

from docopt import docopt
try:
    from schema import Schema, And, Or, Use, SchemaError
except ImportError:
    exit('This example requires that `schema` data-validation library'
         ' is installed: \n    pip install schema\n'
         'https://github.com/halst/schema')

import rospy
# from sbg_driver.msg import gps
# from ros_arduino.msg import commands
from arduino_msgs.msg import commands


_convert_to_bool = {
    'true': True,
    '1': True,
    'on': True,
    'false': False,
    '0': False,
    'off': False
}

_keys_for_booleans = ('true', 'false', '1', '0', 'on', 'off')


def talker(**kwargs):
    topic = kwargs.get('--topic', '/Arduino/commands')
    pub = rospy.Publisher(topic, commands, queue_size=2)

    rospy.init_node('custom_talker', anonymous=True)

    msg = commands()

    # GPS time
    gps_time_from_args = kwargs['--gps_time']
    update_clock = gps_time_from_args is not None
    print("update_clock: %s" % update_clock)
    msg.update_clock = update_clock
    # faudrait swizzler les parametres
    msg.t2_t3_t4 = gps_time_from_args if update_clock else [0] * 3

    # States
    msg.state_flash = kwargs['--flash'] if kwargs['--flash'] else False
    msg.state_start = kwargs['--start'] if kwargs['--start'] else False
    msg.state_pause = kwargs['--pause'] if kwargs['--pause'] else False
    msg.state_boot = kwargs['--boot'] if kwargs['--boot'] else False

    #
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

    # TODO: il faudrait verifier que le topic transmis en argument
    # soit un topic (subscriber) actif ROS.
    # urls:
    # - https://github.com/docopt/docopt/issues/52
    schema_for_boolean = Or(None,
                            And(
                                lambda n: n.lower() in _keys_for_booleans,
                                Use(lambda l: _convert_to_bool[l.lower()])
                            ),
                            error='--flash=BOOL should be boolean.')
    schema = Schema({
        '--help': Or(None, And(Use(bool), lambda n: True)),
        '--version': Or(None, And(Use(bool), lambda n: True)),
        '--rate': Or(None, And(Use(float), lambda n: 0.0 <= n < 100.0),
                     error='--rate=N should be float 0.0 <= N <= 100.0'),
        '--topic': Or(None, And(Use(str), lambda n: True),
                      error='--topic=TOPIC should be string of ROS topic'),
        '--gps_time': Or(None, And(Use(lambda s: map(int, s.split(':'))),
                                   lambda l: len(l) == 3),
                         error='--gps_time=<d:d:d>'),
        '--flash': schema_for_boolean,
        '--start': schema_for_boolean,
        '--pause': schema_for_boolean,
        '--boot': schema_for_boolean,
    }
    )
    try:
        args = schema.validate(args)
    except SchemaError as e:
        exit(e)

    print("args: %s" % args)

    try:
        talker(**args)
    except rospy.ROSInterruptException:
        pass
