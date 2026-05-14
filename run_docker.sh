#!/bin/bash

# 允许本地 root 用户访问 X11 服务以显示图形界面
xhost +local:root > /dev/null

# 容器名称
CONTAINER_NAME="noetic_gazebo_env"

# 如果容器已经在运行，先停止并删除（可选，方便调试）
docker rm -f $CONTAINER_NAME 2>/dev/null

docker run -it \
    --name $CONTAINER_NAME \
    --privileged \
    --network host \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v /dev/dri:/dev/dri \
    -v $(pwd)/src:/root/colcon_ws/src \
    gazebo_img \
    /bin/bash