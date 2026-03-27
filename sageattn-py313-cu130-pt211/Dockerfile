################################################################################
# Dockerfile that builds 'yanwk/comfyui-extras:sageattn-py313-cu130-pt211'.
# Used for compiling SageAttention.
################################################################################

ARG REGISTRY=docker.io

FROM ${REGISTRY}/yanwk/comfyui-boot:base-cu130-pt211 AS buildingStage

RUN set -eu \
    && mkdir -p /WORK/wheels

# Limit CPU/RAM usage during builds. Set to 1 to avoid crash on GitHub CI.
ARG MAX_JOBS=1

################################################################################
# SageAttention
RUN git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
https://github.com/thu-ml/SageAttention.git \
/WORK/SageAttention

# TORCH_CUDA_ARCH_LIST can only contain architectures supported by both PyTorch and SageAttention.
# Check before set:
# https://github.com/pytorch/pytorch/blob/v2.11.0/.ci/manywheel/build_cuda.sh
# https://github.com/thu-ml/SageAttention/blob/main/setup.py
# Or check in Python:
# python3.13 -c 'import torch; print(torch._C._cuda_getArchFlags())'

ARG TORCH_CUDA_ARCH_LIST='8.0;8.6;9.0;10.0;12.0'

WORKDIR /WORK/SageAttention

RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/WORK/SageAttention/build \
    --mount=type=cache,target=/WORK/SageAttention/dist \
    python3.13 setup.py bdist_wheel -d /WORK/wheels
    # python3.13 setup.py build_ext --inplace

################################################################################
# SageAttention 3 (Blackwell only)

ARG TORCH_CUDA_ARCH_LIST='10.0;12.0'

WORKDIR /WORK/SageAttention/sageattention3_blackwell

RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/WORK/SageAttention/sageattention3_blackwell/build \
    --mount=type=cache,target=/WORK/SageAttention/sageattention3_blackwell/dist \
    python3.13 setup.py bdist_wheel -d /WORK/wheels

################################################################################
# SpargeAttention
RUN git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
https://github.com/thu-ml/SpargeAttn.git \
/WORK/SpargeAttn

ARG TORCH_CUDA_ARCH_LIST='8.0;8.6;9.0;10.0;12.0'

WORKDIR /WORK/SpargeAttn

RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/WORK/SpargeAttn/build \
    --mount=type=cache,target=/WORK/SpargeAttn/dist \
    python3.13 setup.py bdist_wheel -d /WORK/wheels

################################################################################
# Save the result
FROM ${REGISTRY}/library/alpine:latest AS savingStage

LABEL maintainer="YAN Wenkun <code@yanwk.fun>"

COPY --from=buildingStage /WORK/wheels /wheels
