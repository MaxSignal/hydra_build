# FROM osrf/ros:noetic-desktop-full
FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=ASIA/Tokyo
# ENV NVIDIA_VISIBLE_DEVICES=${NVIDIA_VISIBLE_DEVICES:-all}
# ENV NVIDIA_DRIVER_CAPABILITIES=${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

WORKDIR /root

RUN apt-get update \
    && apt-get upgrade -y 

RUN apt-get install -y --no-install-recommends wget \
                    unzip \
                    curl \ 
                    git \ 
                    vim \ 
                    lsb-release \
                    gnupg \
                    python3 \ 
                    python3-pip \ 
                    python3-dev \ 
                    python3-venv 

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN apt-get update
RUN apt-get install -y ros-noetic-desktop-full
RUN apt-get install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential

RUN ls /opt/ros/noetic
RUN bash -c "source /opt/ros/noetic/setup.bash"
RUN echo "source /opt/ros/noetic/setup.bash" >> .bashrc
RUN rosdep init
RUN rosdep update

RUN apt install python3-rosdep python3-catkin-tools python3-vcstool -y
RUN mkdir catkin_ws
WORKDIR /root/catkin_ws
RUN mkdir src
RUN catkin init
RUN catkin config -DCMAKE_BUILD_TYPE=Release

WORKDIR /root/catkin_ws/src
RUN git config --global url."https://github.com/".insteadOf git@github.com:
RUN git clone git@github.com:MIT-SPARK/Hydra.git hydra
RUN vcs import . < hydra/install/hydra.rosinstall
RUN rosdep install --from-paths . --ignore-src -r -y

WORKDIR /root/catkin_ws
RUN catkin build

RUN bash -c "source /root/catkin_ws/devel/setup.bash"
RUN echo "source /root/catkin_ws/devel/setup.bash" >> /root/.bashrc
