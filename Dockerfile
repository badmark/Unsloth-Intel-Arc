# Use the Intel image - Ubuntu 24.04 (Forces native Python 3.12)
FROM intel/oneapi:2025.1.3-0-devel-ubuntu24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/usr/local/bin:${PATH}"

# Install core runtime dependencies, including python3-venv and Intel compute runtimes for Arc GPUs
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    git \
    python3-pip \
    python3-dev \
    python3-venv \
    intel-opencl-icd \
    clinfo \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.unsloth/studio && \
    python3 -m venv /root/.unsloth/studio/unsloth_studio

RUN /root/.unsloth/studio/unsloth_studio/bin/pip install --no-cache-dir \
    torch==2.11.0+xpu torchvision torchaudio \
    --index-url https://pytorch.org

RUN /root/.unsloth/studio/unsloth_studio/bin/pip install --no-cache-dir \
    intel-cmplr-lib-rt intel-cmplr-lib-ur intel-cmplr-lic-rt intel-sycl-rt pytorch-triton-xpu \
    --index-url https://pytorch.org

ENV UNSLOTH_BACKEND=auto
RUN /root/.unsloth/studio/unsloth_studio/bin/pip install --no-cache-dir unsloth --no-deps && \
    /root/.unsloth/studio/unsloth_studio/bin/pip install --no-cache-dir unsloth_zoo --no-deps

RUN /root/.unsloth/studio/unsloth_studio/bin/pip install --no-cache-dir bitsandbytes && \
    /root/.unsloth/studio/unsloth_studio/bin/pip install --no-cache-dir \
    transformers datasets accelerate peft trl scipy sentencepiece wheel packaging \
    structlog python-multipart fastapi uvicorn pydantic click tyro sqlmodel unsloth-studio

RUN sed -i 's/raise NotImplementedError("Unsloth cannot find any torch accelerator? You need a GPU.")/return "xpu"/g' /root/.unsloth/studio/unsloth_studio/lib/python3.12/site-packages/unsloth_zoo/device_type.py

RUN /root/.unsloth/studio/unsloth_studio/bin/unsloth studio setup

EXPOSE 8888
USER root

ENTRYPOINT ["/bin/bash", "-c", "export LD_LIBRARY_PATH=/root/.unsloth/studio/unsloth_studio/lib/python3.12/site-packages/torch/lib:/usr/local/lib:$LD_LIBRARY_PATH && /root/.unsloth/studio/unsloth_studio/bin/unsloth studio -H 0.0.0.0 -p 8888"]
