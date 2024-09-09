# CUDA images: https://catalog.ngc.nvidia.com/orgs/nvidia/containers/cuda/tags
FROM nvcr.io/nvidia/cuda:12.6.1-cudnn-devel-ubuntu24.04

# Ubuntu 24.04 comes with GCC 13

# Note about env vars: in NVIDIA's image, there's no CUDA_HOME or CUDA_PATH.
# Also, the LD_LIBRARY_PATH is intended to point to a non-existent folder.
# Ref: https://gitlab.com/nvidia/container-images/cuda/-/issues/47

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
python3.12-full \
python3.12-dev \
libegl1-mesa-dev \
git \
cmake \
ninja-build \
aria2 \
curl \
fish \
fd-find \
less \
vim \
ffmpeg \
x264 \
x265 \
    && rm /usr/lib/python3.12/EXTERNALLY-MANAGED \
    && rm -rf /var/lib/apt/lists/*

RUN --mount=type=cache,target=/root/.cache/pip \
    aria2c https://bootstrap.pypa.io/get-pip.py \
    && python3 get-pip.py \
    && rm get-pip.py \
    && pip install \
        wheel setuptools
