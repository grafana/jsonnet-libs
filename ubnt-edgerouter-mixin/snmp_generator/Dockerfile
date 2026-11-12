FROM golang:latest@sha256:ec47ea3725fea0cc88f6de94919aef19f40f12fc1ec0e2d1b3426dbf15ecca04

RUN apt-get update && \
    apt-get install -y libsnmp-dev p7zip-full unzip && \
    go install github.com/prometheus/snmp_exporter/generator@latest

WORKDIR "/opt"

ENTRYPOINT ["/go/bin/generator"]

ENV MIBDIRS mibs

CMD ["generate"]
