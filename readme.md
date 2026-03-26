构建 image，第一次运行的时候使用一次即可
docker build -t gazebo_img .

运行doecker
./run_docker.sh

开启另外的docker环境终端
docker exec -it noetic_gazebo_env /bin/bash