#!/usr/bin/env python
import rospy
from ros_arduino.msg import gps


def talker():
    pub = rospy.Publisher('/Arduino/gps', gps, queue_size=2)

    rospy.init_node('custom_talker', anonymous=True)

    r = rospy.Rate(1)

    # msg = gps(
    #     t2_t3_t4=[59, 59, 23],
    #     gprmc_pos=str("gprmc_pos")
    # )
    # print("msg: ", msg)
    msg = gps()
    msg.t2_t3_t4 = [59, 59, 23]
    msg.gprmc_pos = "Salut"

    while not rospy.is_shutdown():
        rospy.loginfo(msg)
        pub.publish(msg)
        r.sleep()


if __name__ == '__main__':
    try:
        talker()
    except rospy.ROSInterruptException:
        pass
