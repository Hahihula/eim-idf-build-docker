# EIM IDF Build Docker

This repository contains a proof of concept for non-interactive installation of [ESP-IDF Managed Installation (EIM)](https://github.com/espressif/idf-installer) using Docker. The Docker image provides a ready-to-use environment for building ESP-IDF projects without manual setup.

## Features

- **Non-interactive Installation**: Demonstrates the newly introduced feature of EIM that allows for automated, non-interactive installation
- **Multi-architecture Support**: Builds available for multiple platforms (amd64, arm64)
- **Pre-configured Environment**: Comes with ESP-IDF v5.3.1 pre-installed
- **CI/CD Ready**: Can be used in continuous integration pipelines

## Quick Start

To build your ESP-IDF project using this Docker image, navigate to your project directory and run:

```bash
docker run --rm -it -v $(pwd):/tmp/project hahihula/eim-idf-build:latest
```

This command will:

1. Mount your current directory to `/tmp/project` inside the container
2. Execute the ESP-IDF build process
3. Output the build artifacts in your project directory

## Prerequisites

- Docker installed on your system
- An ESP-IDF project with a valid `CMakeLists.txt` file

## How It Works

The Docker image:

1. Uses a minimal Debian (Bookworm) base image
2. Installs necessary build dependencies
3. Downloads and installs EIM in non-interactive mode
4. Sets up ESP-IDF v5.3.1
5. Provides an entrypoint that automatically builds mounted projects

## Usage Examples

### Basic Build

```bash
# From your project directory
docker run --rm -it -v $(pwd):/tmp/project hahihula/eim-idf-build:latest
```

### Specify Different IDF Target

```bash
# Add IDF_TARGET environment variable
docker run --rm -it -v $(pwd):/tmp/project -e IDF_TARGET=esp32s3 hahihula/eim-idf-build:latest
```

## Building the Docker Image Locally

If you want to build the image locally:

```bash
git clone https://github.com/yourusername/eim-idf-build.git
cd eim-idf-build
docker build -t eim-idf-build .
```

## Technical Details

The Docker image uses:

- Base image: `bitnami/minideb:bookworm`
- ESP-IDF version: v5.3.1
- EIM version: v0.1.5

## Contributing

Feel free to submit issues and enhancement requests!

## License

[Add your license here]

## Notes

- This is a proof of concept demonstrating non-interactive EIM installation
- The image is primarily intended for CI/CD pipelines and automated builds
- While the container includes an interactive shell, it's recommended to use the standard ESP-IDF installation for development work

## Related Links

- [ESP-IDF GitHub Repository](https://github.com/espressif/esp-idf)
- [EIM GitHub Repository](https://github.com/espressif/idf-installer)
- [Docker Hub Image](https://hub.docker.com/r/hahihula/eim-idf-build)
