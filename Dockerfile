ARG UBUNTU_VERSION=24.04
ARG OTEL_VERSION=0.95.0
ARG ALPINE_VERSION=3.19.1

FROM otel/opentelemetry-collector-contrib:${OTEL_VERSION} AS otelcol

FROM alpine:${ALPINE_VERSION} as certs
RUN apk --update add ca-certificates

FROM alpine:${ALPINE_VERSION} as directories
RUN mkdir /etc/otel/

FROM ubuntu:${UBUNTU_VERSION} as systemd
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y systemd
# prepare package with journald and it's dependencies keeping original paths
# h stands for dereference of symbolic links
RUN tar czhf journalctl.tar.gz /bin/journalctl $(ldd /bin/journalctl | grep -oP "\/.*? ")
# extract package to /output so it can be taken as base for scratch image
# we do not copy archive into scratch image, as it doesn't have tar executable
# however, we can copy full directory as root (/) to be base file structure for scratch image
RUN mkdir /output && tar xf /journalctl.tar.gz --directory /output

FROM scratch
ARG BUILD_TAG=latest
ENV TAG $BUILD_TAG
ARG USER_UID=10001
USER ${USER_UID}
ENV HOME /etc/otel/

# copy journalctl and it's dependencies as base structure
COPY --from=systemd /output/ /usr/local/bin/
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=otelcol /otelcol-contrib /otelcol-contrib
COPY --from=directories --chown=${USER_UID}:${USER_UID} /etc/otel/ /etc/otel/

ENTRYPOINT ["/otelcol-contrib"]
CMD ["--config", "/etc/otel/config.yaml"]