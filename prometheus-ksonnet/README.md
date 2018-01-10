# Prometheus Ksonnet Mixin

A set of extensible configs for running Prometheus on Kubernetes.

Usage:
- Make sure you have the [ksonnet v0.8.0](https://github.com/ksonnet/ksonnet).

```
$ brew install ksonnet/tap/ks
$ ks version
ksonnet version: v0.8.0
jsonnet version: v0.9.5
client-go version: v1.6.8-beta.0+$Format:%h$
```

- In your config repo, if you don't have a ksonnet application, make a new one (will copy credentials from current context):

```
$ ks init <application name>
$ cd <application name>
```

- Add the kausal repository, instantiate the package

```
$ ks registry add kausal https://github.com/kausalco/public
$ ks pkg install kausal/prometheus-ksonnet
```

- Assuming you want to run in the default namespace ('environment' in ksonnet parlance), add the follow to the file `environments/default/main.jsonnet`:

```
local prometheus = import "prometheus-ksonnet/prometheus-ksonnet.libsonnet";

prometheus {
  _config+:: {
    namespace: "default",
  },
}
```

- Apply your config:

```
$ ks apply default
```

# Kops

If you made your Kubernetes cluster with [Kops](https://github.com/kubernetes/kops),
add the Kops mixin to your config to scrape the Kubernetes system components:

```
local prometheus = import "prometheus-ksonnet/prometheus-ksonnet.libsonnet";
local kops = import "prometheus-ksonnet/lib/prometheus-config-kops.libsonnet";

prometheus + kops {
  _config+:: {
    namespace: "default",
    insecureSkipVerify: true,
  },
}
```
