################################################################################
# Dockerfile that builds 'yanwk/comfyui-extras:sageattn-py313-cu130-pt211'.
# Used for compiling SageAttention.
################################################################################

ARG REGISTRY=docker.io

FROM ${REGISTRY}/yanwk/comfyui-boot:base-cu130-pt211-cache AS buildingStage

WORKDIR /WORK/wheels

# Limit CPU/RAM usage during builds. Set to 1 to avoid crash on GitHub CI.
ARG MAX_JOBS=2

ARG BUILD_BUNDLE_PTXAS=1

RUN pip install build "wheel<0.44" "packaging<24"

################################################################################
# Download repo and fix
RUN git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
https://github.com/thu-ml/SageAttention.git \
/WORK/SageAttention

RUN git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
https://github.com/thu-ml/SpargeAttn.git \
/WORK/SpargeAttn

WORKDIR /WORK/SageAttention/sageattention3_blackwell

# Fix for the dumb code asking for a freaking GPU
RUN sed -i \
'/cc_major, cc_minor = torch.cuda.get_device_capability()/,/raise RuntimeError("Unsupported GPU")/c\    cc_flag.append("-gencode")\n    cc_flag.append("arch=compute_100a,code=sm_100a")' \
setup.py

WORKDIR /WORK/SpargeAttn

# Fix for the dumb code incompatible with GCC 14
RUN sed -i \
'/"-include,cassert",/d' \
setup.py

################################################################################
# SageAttention

# TORCH_CUDA_ARCH_LIST can only contain architectures supported by both PyTorch and SageAttention.
# Check before set:
# https://github.com/pytorch/pytorch/blob/v2.11.0/.ci/manywheel/build_cuda.sh
# https://github.com/thu-ml/SageAttention/blob/main/setup.py
# Or check in Python:
# python3.13 -c 'import torch; print(torch._C._cuda_getArchFlags())'

ARG TORCH_CUDA_ARCH_LIST='8.0;8.6;10.0;12.0'

WORKDIR /WORK/SageAttention

RUN python3.13 -m build --wheel --no-isolation --outdir /WORK/wheels .

################################################################################
# SageAttention 3 (Blackwell only)
# https://github.com/thu-ml/SageAttention/blob/main/sageattention3_blackwell/setup.py

ARG TORCH_CUDA_ARCH_LIST='10.0;12.0'

WORKDIR /WORK/SageAttention/sageattention3_blackwell

RUN python3.13 -m build --wheel --no-isolation --outdir /WORK/wheels .

################################################################################
# SpargeAttention
# https://github.com/thu-ml/SpargeAttn/blob/main/setup.py

ARG TORCH_CUDA_ARCH_LIST='8.0;8.6;8.9'

# Fix for dumb autogen.py
RUN alternatives --install /usr/bin/python python /usr/bin/python3.13 100
RUN alternatives --install /usr/bin/python3 python3 /usr/bin/python3.13 100

WORKDIR /WORK/SpargeAttn

RUN python3.13 -m build --wheel --no-isolation --outdir /WORK/wheels .

################################################################################
# Save the result
FROM ${REGISTRY}/library/alpine:latest AS savingStage

LABEL maintainer="YAN Wenkun <code@yanwk.fun>"

COPY --from=buildingStage /WORK/wheels /wheels
