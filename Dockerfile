# syntax=docker/dockerfile:1

FROM bitnami/minideb:bookworm

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required packages including curl and jq for API handling
RUN install_packages git cmake ninja-build wget flex bison gperf ccache \
    libffi-dev libssl-dev dfu-util libusb-1.0-0 python3 python3-pip \
    python3-setuptools python3-wheel xz-utils unzip python3-venv curl jq && \
    rm -rf /var/lib/apt/lists/*

ARG TARGETARCH=arm64
RUN set -x && \
    # Get the latest release info
    LATEST_RELEASE=$(curl -s https://api.github.com/repos/espressif/idf-im-ui/releases/latest) && \
    # Determine correct architecture name for asset pattern
    if [ "$TARGETARCH" = "amd64" ]; then \
        ARCH_PATTERN="linux-x64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        ARCH_PATTERN="linux-aarch64"; \
    else \
        echo "Unsupported architecture: ${TARGETARCH}" && exit 1; \
    fi && \
    # Extract download URL for the CLI tool
    EIM_DOWNLOAD_URL=$(echo "$LATEST_RELEASE" | jq -r --arg PATTERN "eim-cli-$ARCH_PATTERN.zip" \
        '.assets[] | select(.name | contains($PATTERN)) | .browser_download_url') && \
    # Verify a URL was found
    if [ -z "$EIM_DOWNLOAD_URL" ]; then \
        echo "Failed to find download URL for eim-cli-$ARCH_PATTERN.zip" && exit 1; \
    fi && \
    echo "Downloading eim-cli from: $EIM_DOWNLOAD_URL" && \
    # Download and extract
    wget "$EIM_DOWNLOAD_URL" -O /tmp/eim.zip && \
    unzip /tmp/eim.zip -d /tmp/eim && \
    # Find and move the eim binary (handles possible subdirectory in zip)
    find /tmp/eim -name "eim" -type f -exec cp {} /usr/local/bin/eim \; && \
    # Make executable
    chmod +x /usr/local/bin/eim && \
    # Cleanup
    rm -rf /tmp/eim.zip /tmp/eim

# Verify installation and initialize
RUN eim -vvv install -n true -a true -r false

RUN mkdir /tmp/project
WORKDIR /tmp/project

ENTRYPOINT ["/bin/bash", "-c", "source /root/.espressif/tools/activate_idf_v5.3.1.sh && python3 /root/.espressif/v5.3.1/esp-idf/tools/idf.py build"]