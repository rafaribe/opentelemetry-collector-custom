ARG UBUNTU_VERSION=24.04
ARG OTEL_VERSION=0.95.0

FROM otel/opentelemetry-collector-contrib:${OTEL_VERSION} AS otel
FROM ubuntu:${UBUNTU_VERSION} AS final

RUN apt update && apt install systemd -y
COPY --from=otel /otelcol-contrib /
LABEL maintainer "Rafael Ribeiro <rafael.ntw@gmail.com>"
EXPOSE 4317 55680 55679
ENTRYPOINT ["/otelcol-contrib"]

CMD ["--config", "/etc/otel/config.yaml"]