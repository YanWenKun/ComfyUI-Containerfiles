################################################################################
# Dockerfile that builds 'yanwk/comfyui-extras:xformers-cu124'.
# Used for compiling xFormers.
################################################################################

FROM docker.io/yanwk/comfyui-boot:cu124 AS buildingStage

# Compile-install xformers

# TIP: Reduce build-targets to save compiling time!
# If targets "6.1", it takes ~5min to compile, on a Ryzen 1700 (8-Core) CPU.
# If targets "6.1;7.5;8.0;8.6", it takes ~35min.

# https://github.com/facebookresearch/xformers/blob/main/README.md#install-troubleshooting
# https://arnon.dk/matching-sm-architectures-arch-and-gencode-for-various-nvidia-cards/

RUN set -eu \
    && mkdir -p /WORK/wheels

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --break-system-packages \
        -r https://raw.githubusercontent.com/facebookresearch/xformers/main/requirements.txt

RUN git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
        https://github.com/facebookresearch/xformers.git \
        /WORK/xformers

ARG TORCH_CUDA_ARCH_LIST="5.2+PTX"

# Limit max concurrent build jobs. Set to 1 to avoid crash on GitHub CI.
ARG MAX_JOBS

WORKDIR /WORK/xformers

RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/WORK/xformers/build \
    --mount=type=cache,target=/WORK/xformers/dist \
    python3 setup.py bdist_wheel -d /WORK/wheels

# Save the result
FROM docker.io/library/alpine:latest AS savingStage

LABEL maintainer="YAN Wenkun <code@yanwk.fun>"

COPY --from=buildingStage /WORK/wheels /wheels
