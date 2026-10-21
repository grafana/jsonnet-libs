FROM golang:latest@sha256:f20d83a83e18dbd2a4714b8ffd4b30b287b6243962dd75608e86abcc63ba4efc

RUN apt-get update && \
    apt-get install -y libsnmp-dev p7zip-full unzip && \
    go install github.com/prometheus/snmp_exporter/generator@latest

WORKDIR "/opt"

ENTRYPOINT ["/go/bin/generator"]

ENV MIBDIRS mibs

CMD ["generate"]
