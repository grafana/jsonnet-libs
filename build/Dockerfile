# Dockerfile for image used to run CI.

FROM alpine:3.7
RUN apk --no-cache add alpine-sdk git
RUN git clone https://github.com/google/jsonnet
RUN git  -C jsonnet checkout v0.10.0
RUN make -C jsonnet LDFLAGS=-static

FROM alpine:3.7
RUN apk --no-cache add make python git openssh-client
COPY --from=0 jsonnet/jsonnet /usr/bin
