################################################################################
# Containerfile that builds 'yanwk/comfyui-extras:devel-torch'.
# An environment with CUDA devkit & Python devel.
################################################################################

FROM yanwk/comfyui-extras:devel-cu121-py311

LABEL maintainer="code@yanwk.fun"

WORKDIR /root

RUN set -eu

# Even we have CUDA installed by Zypper, we still need to
# install CUDA libs for Python in order to run PyTorch.
# What's more, NVIDIA's openSUSE15 repo didn't provide CuDNN & NCCL,
# we have to use Python packages anyway.
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        xformers torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu121 \
        --extra-index-url https://pypi.org/simple

ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}\
:/usr/lib64/python3.11/site-packages/torch/lib\
:/usr/lib/python3.11/site-packages/nvidia/cuda_cupti/lib\
:/usr/lib/python3.11/site-packages/nvidia/cuda_runtime/lib\
:/usr/lib/python3.11/site-packages/nvidia/cudnn/lib\
:/usr/lib/python3.11/site-packages/nvidia/cufft/lib\
:/usr/lib/python3.11/site-packages/nvidia/cublas/lib\
:/usr/lib/python3.11/site-packages/nvidia/cuda_nvrtc/lib\
:/usr/lib/python3.11/site-packages/nvidia/curand/lib\
:/usr/lib/python3.11/site-packages/nvidia/cusolver/lib\
:/usr/lib/python3.11/site-packages/nvidia/cusparse/lib\
:/usr/lib/python3.11/site-packages/nvidia/nccl/lib\
:/usr/lib/python3.11/site-packages/nvidia/nvjitlink/lib\
:/usr/lib/python3.11/site-packages/nvidia/nvtx/lib"

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
accelerate \
cupy-cuda12x \
diffusers \
ftfy \
imageio \
kornia \
matplotlib \
onnxruntime \
opencv-contrib-python-headless \
opencv-python-headless \
pandas \
scikit-image \
scikit-learn \
scipy \
timm \
transformers \
    && pip check

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install \
        --force-reinstall onnxruntime-gpu \
        --index-url https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple/ \
        --extra-index-url https://pypi.org/simple 
