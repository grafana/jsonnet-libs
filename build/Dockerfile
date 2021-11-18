# Dockerfile for image used to run CI.

# Build jb
FROM alpine:3.14 AS jb-builder
ARG JSONNET_BUNDLER_VERSION=0.4.0
ARG JSONNET_BUNDLER_CHECKSUM="433edab5554a88a0371e11e93080408b225d41c31decf321c02b50d2e44993ce  /usr/bin/jb"
RUN apk add --no-cache curl
RUN curl -fSL -o "/usr/bin/jb" "https://github.com/jsonnet-bundler/jsonnet-bundler/releases/download/v${JSONNET_BUNDLER_VERSION}/jb-linux-amd64"
RUN echo "${JSONNET_BUNDLER_CHECKSUM}" | sha256sum -c || (printf "wanted: %s\n   got: %s\n" "${JSONNET_BUNDLER_CHECKSUM}" "$(sha256sum /usr/bin/jb)"; exit 1)
RUN chmod +x /usr/bin/jb

# Build various golang tools
FROM golang:1.17-alpine AS golang-builder
RUN go install github.com/google/go-jsonnet/cmd/jsonnet@v0.17.0
RUN go install github.com/google/go-jsonnet/cmd/jsonnetfmt@v0.17.0
RUN go install github.com/monitoring-mixins/mixtool/cmd/mixtool@0d5bd3c

FROM alpine:3.14
RUN apk --no-cache add make python3 git openssh-client bash
COPY --from=jb-builder /usr/bin/jb /usr/bin
COPY --from=golang-builder /go/bin/jsonnet /usr/bin
COPY --from=golang-builder /go/bin/jsonnetfmt /usr/bin
COPY --from=golang-builder /go/bin/mixtool /usr/bin
