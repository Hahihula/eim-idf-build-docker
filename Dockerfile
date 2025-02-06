# syntax=docker/dockerfile:1

FROM bitnami/minideb:bookworm

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN install_packages git cmake ninja-build wget flex bison gperf ccache \
    libffi-dev libssl-dev dfu-util libusb-1.0-0 python3 python3-pip \
    python3-setuptools python3-wheel xz-utils unzip python3-venv && \
    rm -rf /var/lib/apt/lists/*

ARG TARGETARCH
RUN set -x && \
    EIM_BINARY="eim-v0.1.6-linux-" && \
    if [ "$TARGETARCH" = "amd64" ]; then \
        EIM_BINARY="${EIM_BINARY}x64.zip"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        EIM_BINARY="${EIM_BINARY}arm64.zip"; \
    else \
        echo "Unsupported architecture: ${TARGETARCH}" && exit 1; \
    fi && \
    echo "Downloading ${EIM_BINARY}" && \
    wget "https://github.com/espressif/idf-im-cli/releases/download/v0.1.6/${EIM_BINARY}" -O /tmp/eim.zip && \
    unzip /tmp/eim.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/eim && \
    rm /tmp/eim.zip

RUN eim -r false -n true -vvv

RUN mkdir /tmp/project
WORKDIR /tmp/project

ENTRYPOINT ["/bin/bash", "-c", "source /root/.espressif/activate_idf_v5.3.1.sh && python3 /root/.espressif/v5.3.1/esp-idf/tools/idf.py build"]