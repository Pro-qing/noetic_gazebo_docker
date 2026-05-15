#!/bin/bash

# 允许本地 root 用户访问 X11 服务以显示图形界面
xhost +local:root > /dev/null

# 容器名称
CONTAINER_NAME="noetic_gazebo_env"

# 检查是否有 NVIDIA 显卡驱动，如果有则启用 GPU 支持及渲染能力
DOCKER_GPU_ARGS=""
if command -v nvidia-smi &> /dev/null; then
    DOCKER_GPU_ARGS="--gpus all -e NVIDIA_DRIVER_CAPABILITIES=all"
    echo "检测到 NVIDIA 显卡，已开启 GPU 渲染支持。"
else
    echo "未检测到 NVIDIA 显卡，将仅尝试使用核显 /dev/dri。"
fi

# 如果容器已经在运行，先停止并删除（可选，方便调试）
docker rm -f $CONTAINER_NAME 2>/dev/null

# 启动 Docker 容器
docker run -it \
    --name $CONTAINER_NAME \
    --privileged \
    --network host \
    $DOCKER_GPU_ARGS \
    -e DISPLAY=$DISPLAY \
    -e QT_X11_NO_MITSHM=1 \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v /dev/dri:/dev/dri \
    -v $(pwd)/src:/root/colcon_ws/src \
    -v $(pwd)/debug:/root/colcon_ws/debug \
    gazebo_img \
    /bin/bash