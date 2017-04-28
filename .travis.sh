#!/bin/bash

set -e

apt-get update && apt-get install -y -q wget sudo lsb-release # for docker 

#before_install:
sh -c "echo \"deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main\" > /etc/apt/sources.list.d/ros-latest.list"
sh -c "echo \"deb http://realsense-alm-public.s3.amazonaws.com/apt-repo `lsb_release -sc` main\" > /etc/apt/sources.list.d/realsense-latest.list"
wget http://packages.ros.org/ros.key -O - | apt-key add -
apt-key adv --keyserver keys.gnupg.net --recv-key D6FB2970
apt-get update
apt-get install -y python-catkin-pkg python-rosdep python-wstool ros-kinetic-catkin librealsense-object-recognition-dev librealsense-persontracking-dev librealsense-slam-dev libopencv-dev
source /opt/ros/$ROS_DISTRO/setup.bash
rosdep init
rosdep update

#install:
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/src
catkin_init_workspace
cd ~/catkin_ws
catkin_make
source devel/setup.bash
cd ~/catkin_ws/src
ln -s $CI_SOURCE_PATH .

#before_script:
cd ~/catkin_ws
rosdep install -q -y -r --from-paths src --ignore-src --rosdistro $ROS_DISTRO

#script:
source /opt/ros/$ROS_DISTRO/setup.bash
cd ~/catkin_ws
catkin_make
