FROM golang:latest@sha256:a386c44c1c90025ad5bc66feea3fef23052bef3bace3609f7e3e10e1f9314f45

RUN apt-get update && \
    apt-get install -y libsnmp-dev p7zip-full unzip && \
    go install github.com/prometheus/snmp_exporter/generator@latest

WORKDIR "/opt"

ENTRYPOINT ["/go/bin/generator"]

ENV MIBDIRS mibs

CMD ["generate"]
