# Dockerfile for image used to run CI.

# Build jsonnet
FROM alpine:3.7 AS jsonnet-builder
RUN apk --no-cache add alpine-sdk git
RUN git clone https://github.com/google/jsonnet
RUN git  -C jsonnet checkout v0.15.0
RUN make -C jsonnet LDFLAGS=-static

# Build jb
FROM alpine:3.11 AS jb-builder
ARG JSONNET_BUNDLER_VERSION=0.4.0
ARG JSONNET_BUNDLER_CHECKSUM="433edab5554a88a0371e11e93080408b225d41c31decf321c02b50d2e44993ce  /usr/bin/jb"
RUN apk add --no-cache curl
RUN curl -fSL -o "/usr/bin/jb" "https://github.com/jsonnet-bundler/jsonnet-bundler/releases/download/v${JSONNET_BUNDLER_VERSION}/jb-linux-amd64"
RUN echo "${JSONNET_BUNDLER_CHECKSUM}" | sha256sum -c || (printf "wanted: %s\n   got: %s\n" "${JSONNET_BUNDLER_CHECKSUM}" "$(sha256sum /usr/bin/jb)"; exit 1)
RUN chmod +x /usr/bin/jb

# Build mixtool
FROM golang:1.15-alpine AS mixtool-builder
RUN GO111MODULE=on go get github.com/monitoring-mixins/mixtool/cmd/mixtool@ae18e31161ea

FROM alpine:3.7
RUN apk --no-cache add make python git openssh-client bash
COPY --from=jsonnet-builder jsonnet/jsonnet /usr/bin
COPY --from=jsonnet-builder jsonnet/jsonnetfmt /usr/bin
COPY --from=jb-builder /usr/bin/jb /usr/bin
COPY --from=mixtool-builder /go/bin/mixtool /usr/bin
