cmake_minimum_required(VERSION 2.8.3)
project(livox_laser_simulation)

## 强制使用 C++14 (ROS Noetic 默认标准)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(catkin REQUIRED COMPONENTS
  roscpp
  sensor_msgs
  tf
)

# 寻找 gazebo 和 ignition-math6
find_package(gazebo REQUIRED)
find_package(ignition-math6 REQUIRED)

# 包含 gazebo 和 math6 的路径
include_directories(${GAZEBO_INCLUDE_DIRS} ${IGNITION-MATH6_INCLUDE_DIRS})
link_directories(${GAZEBO_LIBRARY_DIRS})

include_directories(
         include
        ${catkin_INCLUDE_DIRS}
)

catkin_package(
        INCLUDE_DIRS include
        LIBRARIES livox_laser_simulation
        CATKIN_DEPENDS sensor_msgs tf
)

# 编译 Gazebo 插件动态库
add_library(livox_laser_simulation SHARED src/livox_points_plugin.cpp src/livox_ode_multiray_shape.cpp)

# 链接库 (去掉了写死的 libprotobuf.so.9)
target_link_libraries(livox_laser_simulation 
  ${catkin_LIBRARIES} 
  ${GAZEBO_LIBRARIES} 
  RayPlugin
)


## =========================================================
## Install 配置 (专为 colcon build 依赖的 install 空间设计)
## =========================================================

# 1. 安装编译生成的 .so 插件库 (必须，否则 Gazebo 找不到 livox 插件)
install(TARGETS livox_laser_simulation
  ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  RUNTIME DESTINATION ${CATKIN_GLOBAL_BIN_DESTINATION}
)

# 2. 安装头文件
install(DIRECTORY include/${PROJECT_NAME}/
  DESTINATION ${CATKIN_PACKAGE_INCLUDE_DESTINATION}
  FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp"
)

# 3. 安装运行所需的资源文件夹 (launch, urdf, meshes, rviz, worlds 等)
# 加入 OPTIONAL 是为了防止你本地缺少某个文件夹时 CMake 报错
install(DIRECTORY launch urdf meshes rviz worlds scan_mode
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
  OPTIONAL
)