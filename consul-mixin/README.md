# Consul Monitoring Mixin

<img align="right" width="200" height="129" src="dashboard.png">

Grafana dashboards and Prometheus alerts for operating Consul, in the form
of a monitoring mixin. They are easiest to use with the [prometheus-ksonnet](https://github.com/kausalco/public/tree/master/prometheus-ksonnet)
package.

To install this mixin, use [ksonnet](https://ksonnet.io/):

```sh
$ ks registry add vault_exporter https://github.com/kausal/public
$ ks pkg install kausal/consul-mixin
```

Then to use, in your environment's `main.jsonnet` file:

```js
local prometheus = (import "prometheus-ksonnet/prometheus-ksonnet.libsonnet");
local consul_mixin = (import "consul-mixin/mixin.libsonnet");

prometheus + consul_mixin {
  _config+:: {
    namespace: "default",
  },
}
```
