################################################################################
# Containerfile that builds 'yanwk/comfyui-extras:devel-cu121-py311'.
# An environment with CUDA devkit & Python devel.
################################################################################

FROM opensuse/tumbleweed:latest

LABEL maintainer="code@yanwk.fun"

WORKDIR /root

RUN set -eu

# Ref: https://gitlab.com/nvidia/container-images/cuda/
RUN --mount=type=cache,target=/var/cache/zypp \
    printf "\
[cuda-opensuse15-x86_64]\n\
name=cuda-opensuse15-x86_64\n\
baseurl=https://developer.download.nvidia.com/compute/cuda/repos/opensuse15/x86_64\n\
enabled=1\n\
gpgcheck=1\n\
gpgkey=https://developer.download.nvidia.com/compute/cuda/repos/opensuse15/x86_64/D42D0685.pub\n" \
        > /etc/zypp/repos.d/cuda-opensuse15.repo \
    && zypper --gpg-auto-import-keys \
        install --no-confirm --no-recommends --auto-agree-with-licenses \
cuda-cccl-12-1 \
cuda-command-line-tools-12-1 \
cuda-compat-12-1 \
cuda-cudart-12-1 \
cuda-cudart-devel-12-1 \
cuda-libraries-12-1 \
cuda-libraries-devel-12-1 \
cuda-minimal-build-12-1 \
cuda-nvcc-12-1 \
cuda-nvml-devel-12-1 \
cuda-nvprof-12-1 \
cuda-nvrtc-devel-12-1 \
cuda-nvtx-12-1 \
libcublas-12-1 \
libcublas-devel-12-1 \
libnpp-12-1 \
libnpp-devel-12-1 \
    && env


ENV PATH="${PATH}:/usr/local/cuda-12.1/bin"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/cuda-12.1/lib64"
ENV LIBRARY_PATH="${LIBRARY_PATH}:/usr/local/cuda-12.1/lib64/stubs"
ENV CUDA_HOME="/usr/local/cuda-12.1"


RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --non-interactive install \
python311-devel \
python311-pip \
python311-wheel \
python311-setuptools \
python311-Cython \
python311-numpy \
Mesa-libGL1 \
libgthread-2_0-0 \
make \
cmake \
ninja \
git \
fish \
fd \
aria2 \
vim \
    && rm /usr/lib64/python3.11/EXTERNALLY-MANAGED


RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --upgrade pip wheel setuptools Cython numpy


RUN --mount=type=cache,target=/var/cache/zypp \
    zypper --non-interactive install \
gcc12 \
gcc12-c++ \
cpp12 \
    && update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-12 90 \
    && update-alternatives --install /usr/bin/cc  cc  /usr/bin/gcc-12 90 \
    && update-alternatives --install /usr/bin/cpp cpp /usr/bin/cpp-12 90 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-12 90 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 90 \
    && update-alternatives --install /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-12 90 \
    && update-alternatives --install /usr/bin/gcc-nm gcc-nm /usr/bin/gcc-nm-12 90 \
    && update-alternatives --install /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-12 90 \
    && update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-12 90 \
    && update-alternatives --install /usr/bin/gcov-dump gcov-dump /usr/bin/gcov-dump-12 90 \
    && update-alternatives --install /usr/bin/gcov-tool gcov-tool /usr/bin/gcov-tool-12 90 
