# Use an official Python runtime as a parent image
FROM osrf/ros:noetic-desktop-full

MAINTAINER Suresh Guttikonda "sugu02@dfki.de"

ARG USER_ID
ARG GROUP_ID

# To avoid tzdata asking for geographic location...
ENV DEBIAN_FRONTEND=noninteractive

# Create a non-root user and home directory
RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --home "/home/user" --uid $USER_ID --gid $GROUP_ID user
RUN chown -R user:user /home/user

# Set the working directory to /home/user
ENV DIRPATH /home/user
WORKDIR $DIRPATH

# Switch to root user
USER root

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get update && apt-get install -y \
    git wget libtool automake nano \
    cmake build-essential unzip pkg-config autoconf \
    python3-dev python3-pip python3-scipy python3-matplotlib \
    libboost-all-dev \
    libjpeg-dev libpng-dev libtiff-dev \
    libvtk7-dev libgtk-3-dev \
    libatlas-base-dev gfortran \
    libparmetis-dev \
    python3-wstool python3-catkin-tools

# Install 
RUN apt-get update && apt-get install -y ros-noetic-image-geometry ros-noetic-pcl-ros ros-noetic-cv-bridge ros-noetic-rqt-multiplot

# Install Realsense
RUN apt-get update && apt-get install -y ros-noetic-realsense2-camera ros-noetic-realsense2-description

# Install GTSAM
RUN apt-get update && apt-get install -y libtbb-dev

# Install PGMO
RUN apt-get update && apt-get install -y ocl-icd-opencl-dev opencl-headers opencl-clhpp-headers

# Create Virtual Environment
RUN pip install virtualenv
RUN virtualenv /opt/venv --python=python3
RUN /opt/venv/bin/pip install numpy==1.19.5 jinja2==3.0.3 pyyaml==6.0.1

# Switch to non-root user
USER user

# Create the workspace and build kalibr in it
ENV WORKSPACE $DIRPATH/catkin_ws

# Setup catkin workspace
RUN mkdir -p $WORKSPACE/src && \
    cd $WORKSPACE && \
    catkin init && \
    catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release -DGTSAM_TANGENT_PREINTEGRATION=OFF && \
    catkin config --merge-devel

# Install Kimera-VIO-ROS
# RUN cd $WORKSPACE/src && \
#     git clone https://github.com/MIT-SPARK/Kimera-VIO-ROS.git && \
#     wstool init && \
#     wstool merge Kimera-VIO-ROS/install/kimera_vio_ros_https.rosinstall -y && \
#     wstool update
ADD --chown=user:group . $WORKSPACE/src/Kimera-VIO-ROS
RUN cd $WORKSPACE/src && \
    wstool init && \
    wstool merge Kimera-VIO-ROS/install/kimera_vio_ros_https.rosinstall -y && \
    wstool update

# https://github.com/MIT-SPARK/Kimera-VIO/issues/230
RUN cd $WORKSPACE/src/gtsam && \
    git reset --hard 686e16aaae26c9a4f23d4af7f2d4a504125ec9c3

# Compile code
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
    cd $WORKSPACE && \
    catkin build -j$(nproc)
