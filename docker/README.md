# Kimera Docker

## Build Docker Image

1. Set up noVNC
2. Build a ROS desktop container image.
`$ docker build --rm -t kimera_ros -f ./docker/Dockerfile --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) .`
3. Start a ROS desktop container, running roscore.
`$ ./docker/kimera_roscore.bash`

## In RealSense D455 (calibration)
1. Run RVIZ for visualization.
`$ ./docker/kimera_rviz.bash`
```shell
$ source catkin_ws/devel/setup.bash
$ rosrun rviz rviz -d $(rospack find kimera_vio_ros)/rviz/kimera_rs_455.rviz
```
2. Run RealSense D455 Camera.
`$ ./kimera_rs_d455.bash`
```shell
$ source catkin_ws/devel/setup.bash
$ roslaunch kimera_vio_ros rs_d455_camera.launch
```
3. Run RealSense D455 rosbag.
`$ ./kimera_rosbag.bash`
```shell
$ source catkin_ws/devel/setup.bash
$ cd /opt/shared
$ rosbag record /camera/imu /camera/color/image_raw /camera/depth/image_rect_raw /camera/infra1/image_rect_raw /camera/infra2/image_rect_raw -O d455_calib.bag
$ rqt_bag d455_calib.bag
$ rosbag info d455_calib.bag
```

## In Euroc dataset (without semantics)
1. Run RVIZ for visualization.
`$ ./kimera_rviz.bash`
```shell
$ source catkin_ws/devel/setup.bash
$ rosrun rviz rviz -d $(rospack find kimera_semantics_ros)/rviz/kimera_semantics_euroc.rviz
```
2. Run Kimera VIO.
`$ ./kimera_vio_ros.bash`
```shell
$ source catkin_ws/devel/setup.bash
$ roslaunch kimera_vio_ros kimera_vio_ros_euroc.launch run_stereo_dense:=true online:=true
```
3. Run Kimera Semantics.
`$ ./kimera_semantics_ros.bash`
```shell
$ source catkin_ws/devel/setup.bash
$ roslaunch kimera_semantics_ros kimera_semantics_euroc.launch
```
4. Run Euroc rosbag.
`$ ./kimera_rosbag.bash`
```shell
$ source catkin_ws/devel/setup.bash
$ rosbag play --clock /opt/shared/euroc_dataset/sequences/V1_01_easy.bag
```

## In Simulation dataset (with semantics)
1. Run RVIZ for visualization.
`$ ./kimera_rviz.bash`
```shell
$ source catkin_ws/devel/setup.bash
$ rosrun rviz rviz -d $(rospack find kimera_semantics_ros)/rviz/kimera_semantics_gt.rviz
```
2. Run Kimera Semantics + Simulation rosbag.
`$ ./kimera_semantics_ros.bash`
```shell
$ source catkin_ws/devel/setup.bash
$ roslaunch kimera_semantics_ros kimera_semantics.launch play_bag:=true
```

## In RealSense D455 (without semantics)
1. Run RVIZ for visualization.
`$ ./kimera_rviz.bash`
```shell
$ source catkin_ws/devel/setup.bash
$ rosrun image_view image_view image:=/camera/infra1/image_rect_raw
$ rosrun rviz rviz -d $(rospack find kimera_vio_ros)/rviz/kimera_vio_euroc.rviz
```
2. Run RealSense D455 Camera.
`$ ./kimera_rs_d455.bash`
```shell
$ source catkin_ws/devel/setup.bash
$ roslaunch kimera_vio_ros rs_d455_camera.launch
```
3. Run Kimera VIO.
`$ ./kimera_vio_ros.bash`
```shell
$ source catkin_ws/devel/setup.bash
$ roslaunch kimera_vio_ros kimera_vio_ros_realsense_IR.launch
```