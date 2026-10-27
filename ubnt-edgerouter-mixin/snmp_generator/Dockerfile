FROM golang:latest@sha256:9048d5e7751706200eb1719c7dae0436950d362f29a1da91fa05e5c63867c60f

RUN apt-get update && \
    apt-get install -y libsnmp-dev p7zip-full unzip && \
    go install github.com/prometheus/snmp_exporter/generator@latest

WORKDIR "/opt"

ENTRYPOINT ["/go/bin/generator"]

ENV MIBDIRS mibs

CMD ["generate"]
