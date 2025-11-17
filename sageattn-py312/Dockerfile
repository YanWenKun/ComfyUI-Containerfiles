################################################################################
# Dockerfile that builds 'yanwk/comfyui-extras:sageattn-py312'.
# Used for compiling xFormers.
################################################################################

FROM docker.io/yanwk/comfyui-boot:cu128-megapak-pt28 AS buildingStage

RUN set -eu \
    && mkdir -p /WORK/wheels

# Limit CPU/RAM usage during builds. Set to 1 to avoid crash on GitHub CI.
ARG MAX_JOBS=2

################################################################################
# SageAttention
RUN git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
https://github.com/thu-ml/SageAttention.git \
/WORK/SageAttention

ARG TORCH_CUDA_ARCH_LIST='8.0;8.6;8.9'

WORKDIR /WORK/SageAttention

RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/WORK/SageAttention/build \
    --mount=type=cache,target=/WORK/SageAttention/dist \
    python3 setup.py bdist_wheel -d /WORK/wheels

################################################################################
# SageAttention 3 (Blackwell only. May not work since its doc asks for Python 3.13+)

ARG TORCH_CUDA_ARCH_LIST='10.0;12.0'

WORKDIR /WORK/SageAttention/sageattention3_blackwell

RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/WORK/SageAttention/sageattention3_blackwell/build \
    --mount=type=cache,target=/WORK/SageAttention/sageattention3_blackwell/dist \
    python3 setup.py bdist_wheel -d /WORK/wheels

################################################################################
# SpargeAttention
RUN git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
https://github.com/thu-ml/SpargeAttn.git \
/WORK/SpargeAttn

ARG TORCH_CUDA_ARCH_LIST='8.0;8.6;8.9;9.0'

WORKDIR /WORK/SpargeAttn

RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/WORK/SpargeAttn/build \
    --mount=type=cache,target=/WORK/SpargeAttn/dist \
    python3 setup.py bdist_wheel -d /WORK/wheels

################################################################################
# Save the result
FROM docker.io/library/alpine:latest AS savingStage

LABEL maintainer="YAN Wenkun <code@yanwk.fun>"

COPY --from=buildingStage /WORK/wheels /wheels
