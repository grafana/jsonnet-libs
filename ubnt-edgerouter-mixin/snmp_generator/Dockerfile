FROM golang:latest@sha256:2920bb124f1a2e12a1d39f0cab756ae0068441ee1da7655dec7f5e374944095b

RUN apt-get update && \
    apt-get install -y libsnmp-dev p7zip-full unzip && \
    go install github.com/prometheus/snmp_exporter/generator@latest

WORKDIR "/opt"

ENTRYPOINT ["/go/bin/generator"]

ENV MIBDIRS mibs

CMD ["generate"]
