################################################################################
# Dockerfile that builds 'yanwk/comfyui-extras:fastvideo-kernel-py313'.
# Used for compiling fastvideo-kernel.
################################################################################

ARG REGISTRY=docker.io

FROM ${REGISTRY}/yanwk/comfyui-boot:base-cu130-pt211-cache AS buildingStage

WORKDIR /WORK/wheels

# Limit CPU/RAM usage during builds. Set to 1 to avoid crash on GitHub CI.
ARG MAX_JOBS=2

################################################################################

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install uv build

RUN git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
https://github.com/hao-ai-lab/FastVideo.git \
/WORK/FastVideo

# Fix for CMAKE missing package configuration file
ENV CMAKE_PREFIX_PATH=/usr/local/lib64/python3.13/site-packages/torch/share/cmake
ENV CUDACXX=$CUDA_HOME/bin/nvcc
ARG TORCH_CUDA_ARCH_LIST='7.5;8.0;8.6;8.9;10.0'

WORKDIR /WORK/FastVideo/fastvideo-kernel

RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/WORK/FastVideo/fastvideo-kernel/build \
    --mount=type=cache,target=/WORK/FastVideo/fastvideo-kernel/dist \
    # pip wheel . --wheel-dir /WORK/wheels --no-build-isolation
    python3.13 -m build --wheel --no-isolation --outdir /WORK/wheels .

################################################################################
# Save the result
FROM ${REGISTRY}/library/alpine:latest AS savingStage

LABEL maintainer="YAN Wenkun <code@yanwk.fun>"

COPY --from=buildingStage /WORK/wheels /wheels
