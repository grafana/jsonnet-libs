FROM golang:1.9.2
RUN apt-get update && apt-get install -y \
  protobuf-compiler \
  libprotobuf-dev
RUN go get -u \
  github.com/golang/protobuf/proto \
  github.com/golang/protobuf/protoc-gen-go \
  google.golang.org/grpc
RUN \
  curl -L -o /tmp/docker-17.03.0-ce.tgz https://get.docker.com/builds/Linux/x86_64/docker-17.03.0-ce.tgz && \
  tar -xz -C /tmp -f /tmp/docker-17.03.0-ce.tgz && \
  mv /tmp/docker/* /usr/bin
