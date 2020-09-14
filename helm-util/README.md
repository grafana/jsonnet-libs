---
permalink: /
---

# package helm-util

```jsonnet
local helm-util = import "github.com/grafana/jsonnet-libs/helm-util/helm.libsonnet"
```

Package `helm-util` allows to consume Helm Charts as plain Jsonnet resources.

### Usage

> **Warning:** [Functionality required](#internals) by this library is still
> experimental and may break at any time.

The [`helm.template`](#fn-helmtemplate) function to converts a Helm Chart into Jsonnet objects,
to be consumed by tools like [Grafana Tanka](https://tanka.dev).

Helm Charts are required to be available on the local file system and are
resolved relative to the file that calls `helm.template`:

```jsonnet
local helm = (import 'github.com/grafana/jsonnet-libs/helm-util/helm.libsonnet').new(std.thisFile);

{
  // render the Grafana Chart, set namespace to "test"
  grafana: helm.template('grafana', './charts/grafana', {
    values: {
      persistence: { enabled: true },
      plugins: ['grafana-clock-panel'],
    },
    namespace: "test"
  }),
}

```

### Chart Management

To simplify Chart vendoring, Tanka includes a special tool at `tk tool vendor`:

```bash
# create a chartfile.yaml, similar to jsonnetfile.json
$ tk tool charts init

# install the Grafana Chart to ./charts/grafana
$ tk tool charts add stable/grafana@5.5.5
```

### Internals

The functionality of `helm-util` is based on the `helm template` command.
Because Jsonnet does not support executing arbitrary command for [good
reasons](https://jsonnet.org/ref/language.html#independence-from-the-environment-hermeticity),
a different way was required.

To work around this, [Tanka](https://tanka.dev) instead binds special
functionality into Jsonnet that exposes this functionality.

This however means this library and all libraries using this library are not
compatible with `google/go-jsonnet` or `google/jsonnet`.


## Index

* [`fn patchKubernetesObjects(object, patch)`](#fn-patchkubernetesobjects)
* [`fn patchLabels(object, labels)`](#fn-patchlabels)
* [`fn template(name, chart, conf)`](#fn-template)

## Fields

### fn patchKubernetesObjects

```ts
patchKubernetesObjects(object, patch)
```

`patchKubernetesObjects` applies `patch` to all Kubernetes objects it finds in `object`.

### fn patchLabels

```ts
patchLabels(object, labels)
```

`patchLabels` finds all Kubernetes objects and adds labels to them.

### fn template

```ts
template(name, chart, conf)
```

`template` expands the Helm Chart to it's underlying resources and returns them in an `Object`,
so they can be consumed and modified from within Jsonnet.

This functionality requires Helmraiser support in Jsonnet (e.g. using Grafana Tanka) and also
the `helm` binary installed on your `$PATH`.
