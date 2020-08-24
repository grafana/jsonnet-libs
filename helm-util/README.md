---
permalink: /
---

# package helm-util

```jsonnet
local helm-util = import "github.com/grafana/jsonnet-libs/helm-util/helm.libsonnet"
```

Package `helm-util` allows to consume Helm Charts as plain Jsonnet resources.

### Usage

Use the [`helm.template`](#fn-helmtemplate) function to convert a Helm Chart into Jsonnet objects,
to be consumed by tools like [Grafana Tanka](https://tanka.dev):

```jsonnet
local helm = import 'github.com/grafana/jsonnet-libs/helm-util/helm.libsonnet';

{
  // render the Grafana Chart at version 5.5.5
  grafana: helm.template('grafana', 'grafana', {
    values: {
      persistence: { enabled: true },
      plugins: ['grafana-clock-panel'],
    },
    flags: ['--version=5.5.5'],
  }),
}

```

Please keep in mind you are responsible for a properly set-up `helm` command
with access to the required Charts.

### Internals

The functionality of `helm-util` is based on the `helm template` command.
Because Jsonnet does not support executing arbitrary command for [good
reasons](https://jsonnet.org/ref/language.html#independence-from-the-environment-hermeticity),
a different way was required.

For the time being, this library requires a special Jsonnet extension called
[Helmraiser](https://github.com/grafana/tanka/tree/master/pkg/helmraiser).

Compilers known to include the extension:

- [Grafana Tanka](https://tanka.dev)

The official compilers `google/jsonnet` and `google/go-jsonnet` lack the
extension and are not supported.


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
