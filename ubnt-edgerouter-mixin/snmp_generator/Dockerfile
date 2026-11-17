FROM golang:latest@sha256:205c7636d74e0ffbe3d007162df7d74f859f5a8c8322dfb9f907977686c126cf

RUN apt-get update && \
    apt-get install -y libsnmp-dev p7zip-full unzip && \
    go install github.com/prometheus/snmp_exporter/generator@latest

WORKDIR "/opt"

ENTRYPOINT ["/go/bin/generator"]

ENV MIBDIRS mibs

CMD ["generate"]
