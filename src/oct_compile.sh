#!/bin/bash
# check for ROS on ubuntu
if [ ! -d /opt/ros ]; then
    echo "ROS not installed"
    exit
fi
ROS=(`ls /opt/ros/`) # list of ROSs
ROS=${ROS[-1]}       # latest ROS      
echo "ROS version found: " $ROS
INCLUDE="$(pkg-config --cflags eigen3) -I/opt/ros/$ROS/include/"
LINK="-L/opt/ros/$ROS/lib/ -Wl,-rpath=/opt/ros/$ROS/lib/"

if [[ $(uname -s) == "Linux" ]]; then
    LINK="${LINK} -lrt"
fi
LINK="${LINK} -lrosbag_storage -lcpp_common -lrostime -lconsole_bridge -ltf2 -lroscpp_serialization -lboost_regex -lboost_signals -lboost_system -lbz2"
echo "INCLUDE: " $INCLUDE
echo "LINK: " $LINK

mkoctfile --mex -O rosbag_wrapper.cpp parser.cpp ${INCLUDE} ${LINK}
