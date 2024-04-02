#!/bin/bash

docker run -d --net=ros \
   --name roscore \
   kimera_ros roscore