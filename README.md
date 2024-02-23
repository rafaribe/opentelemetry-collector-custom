# OpenTelemetry Collector Journald distribution

This repository contains a Dockerfile that builds a Docker image based on Debian with additional dependencies and libraries from the `otel/opentelemetry-collector-contrib` image. The resulting image is configured to run the OpenTelemetry Collector Contrib project with specific versions.

## Docker Image Details

The Docker image is built using the following arguments:

- `DEBIAN_VERSION`: Specifies the version of Debian to use as the base image. The default value is `bookworm`.
- `OTEL_VERSION`: Specifies the version of the `otel/opentelemetry-collector-contrib` image to use. The default value is `0.80.0`.
  The Dockerfile uses a multi-stage build approach, where it first creates a temporary `journal` image based on the specified Debian version. This image is used to copy certain system libraries required by the OpenTelemetry Collector Contrib project.
  In the final stage, the Dockerfile pulls the `otel/opentelemetry-collector-contrib` image with the specified version and copies the necessary system libraries from the `journal` image. It also includes additional metadata such as the maintainer's information.

## Usage

To build the Docker image locally, you can use the following command:

```shell
docker build -t my-opentelemetry-collector .
```

Make sure you have Docker installed and navigate to the directory where the Dockerfile is located. This command will build the image using the Dockerfile and tag it with the name `my-opentelemetry-collector`.
To run a container from the built image, use the following command:

```shell
docker run -d my-opentelemetry-collector
```

This will start a container based on the `my-opentelemetry-collector` image in the background.

## Additional Notes

- The Dockerfile installs the `systemd` package in the temporary `journal` image. This package is necessary for copying certain system libraries related to systemd functionality.
- The system libraries are copied from the `journal` image to the final image using the `COPY` command in the Dockerfile.
- The resulting image is tailored specifically for running the OpenTelemetry Collector Contrib project with the desired versions and required system libraries.
  Feel free to explore the Dockerfile and customize it according to your specific needs. For more information on Dockerfile syntax and Docker best practices, refer to the official Docker documentation.
  If you have any questions or encounter any issues with the Dockerfile or the resulting image, please create an issue.

  Thank you for your interest in this Dockerfile and happy containerization!
