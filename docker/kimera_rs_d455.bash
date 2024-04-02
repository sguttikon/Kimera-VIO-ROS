#!/bin/bash

docker run -it --net=ros \
   --name rs_d455 \
   --env="DISPLAY=novnc:0.0" \
   --env="ROS_MASTER_URI=http://roscore:11311" \
   --mount "type=bind,src=/home/guttikonda/Documents/OriginalWorks/Robotics/Kimera-VIO-ROS/shared,dst=/opt/shared" \
   --workdir /home/user \
   --privileged \
   kimera_ros \
   bash