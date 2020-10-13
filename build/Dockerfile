# Dockerfile for image used to run CI.

# Build jsonnet
FROM alpine:3.7 AS jsonnet-builder
RUN apk --no-cache add alpine-sdk git
RUN git clone https://github.com/google/jsonnet
RUN git  -C jsonnet checkout v0.15.0
RUN make -C jsonnet LDFLAGS=-static

# Build mixtool
FROM golang:1.15-alpine AS mixtool-builder
RUN GO111MODULE=on go get github.com/monitoring-mixins/mixtool/cmd/mixtool@59d44357240d

FROM alpine:3.7
RUN apk --no-cache add make python git openssh-client
COPY --from=jsonnet-builder jsonnet/jsonnet /usr/bin
COPY --from=jsonnet-builder jsonnet/jsonnetfmt /usr/bin
COPY --from=mixtool-builder /go/bin/mixtool /usr/bin
