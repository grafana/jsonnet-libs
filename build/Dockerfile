FROM golang:1.9.2
RUN apt-get update && apt-get install -y protobuf-compiler
RUN go get -u \
  github.com/golang/protobuf/proto \
  github.com/golang/protobuf/protoc-gen-go \
  google.golang.org/grpc
