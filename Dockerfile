FROM osrf/ros:noetic-desktop-full

# 安装基础工具和 Gazebo 相关依赖
RUN apt-get update && apt-get install -y \
    pkg-config \
    python3-catkin-tools \
    ros-noetic-gazebo-ros-pkgs \
    ros-noetic-gazebo-ros-control \
    python3-colcon-common-extensions \
    && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /root/colcon_ws