# Grafana Enterprise Metrics Jsonnet library

> **Note:** This library is in alpha and the structure of the library is subject to breaking changes.

A [Jsonnet](https://jsonnet.org/) library that can be used to configure and deploy Grafana Enterprise Metrics to Kubernetes.

## Getting started

[Jsonnet bundler](https://github.com/jsonnet-bundler/jsonnet-bundler) is used to manage Jsonnet dependencies.
Dependencies will be installed into the `/vendor` directory.
To install the library and its dependencies using Jsonnet bundler:

```console
$ jb install github.com/grafana/jsonnet-libs/enterprise-metrics
```

`k.libsonnet` is a Jsonnet library for Kubernetes. Most other Jsonnet libraries for Kubernetes expect this file to exist in your JSONNET_PATH.
To install `k.libsonnet` for Kubernetes 1.18:

```console
$ jb install github.com/jsonnet-libs/k8s-alpha/1.18
$ cat <<EOF > lib/k.libsonnet
> (import "github.com/jsonnet-libs/k8s-alpha/1.18/main.libsonnet")
> + (import "github.com/jsonnet-libs/k8s-alpha/1.18/extensions/kausal-shim.libsonnet")
EOF
```

## Unit Tests

To run the unit tests:

```console
$ make test
```
