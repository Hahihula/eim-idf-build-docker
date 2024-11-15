FROM bitnami/minideb:bookworm

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN install_packages git cmake ninja-build wget flex bison gperf ccache libffi-dev libssl-dev dfu-util libusb-1.0-0 python3 python3-pip python3-setuptools python3-wheel xz-utils unzip python3-venv

# Download and unzip eim
RUN wget https://github.com/espressif/idf-im-cli/releases/download/v0.1.5/eim-v0.1.5-linux-x64.zip -O /tmp/eim.zip && \
    unzip /tmp/eim.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/eim && \
    rm /tmp/eim.zip

RUN eim -r false -n true -vvv

RUN mkdir /tmp/project
WORKDIR /tmp/project

# The build command is moved to the entrypoint to ensure it runs on the mounted code
ENTRYPOINT ["/bin/bash", "-c", "source /root/.espressif/activate_idf_v5.3.1.sh && python3 /root/.espressif/v5.3.1/esp-idf/tools/idf.py build"]
