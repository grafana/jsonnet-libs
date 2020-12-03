---
permalink: /
---

# package tanka-util

```jsonnet
local tanka-util = import "github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet"
```

Package `tanka-util` provides jsonnet tooling that works well with [Grafana
Tanka](https://tanka.dev) features. This package implements [Helm
support](https://tanka.dev/helm) for Grafana Tanka.

### Usage

> **Warning:** [Functionality required](#internals) by this library is still
> experimental and may break.

The [`helm.template`](#fn-helmtemplate) function converts a Helm Chart into
Jsonnet object to be consumed by tools like Tanka.

Helm Charts are required to be available on the local file system and are
resolved relative to the file that calls `helm.template`:

```jsonnet
local tanka = import 'github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet';
local helm = tanka.helm.new(std.thisFile);

{
  // render the Grafana Chart, set namespace to "test"
  grafana: helm.template('grafana', './charts/grafana', {
    values: {
      persistence: { enabled: true },
      plugins: ['grafana-clock-panel'],
    },
    namespace: 'test',
  }),
}

```

For more information on that see https://tanka.dev/helm

### Internals

The functionality of `helm.template` is based on the `helm template` command.
Because Jsonnet does not support executing arbitrary command for [good
reasons](https://jsonnet.org/ref/language.html#independence-from-the-environment-hermeticity),
a different way was required.

To work around this, [Tanka](https://tanka.dev) instead binds special
functionality into Jsonnet that provides `helm template`.

This however means this library and all libraries using this library are not
compatible with `google/go-jsonnet` or `google/jsonnet`.


## Index

* [`obj helm`](#obj-helm)
  * [`fn new(calledFrom)`](#fn-helmnew)
  * [`fn template(name, chart, conf)`](#fn-helmtemplate)
* [`obj util`](#obj-util)
  * [`fn patchKubernetesObjects(object, patch)`](#fn-utilpatchkubernetesobjects)
  * [`fn patchLabels(object, labels)`](#fn-utilpatchlabels)

## Fields

## obj helm

`helm` allows the user to consume Helm Charts as plain Jsonnet resources.
This implements [Helm support](https://tanka.dev/helm) for Grafana Tanka.


### fn helm.new

```ts
new(calledFrom)
```

`new` initiates the `helm` object. It must be called before any `helm.template` call:
 > ```jsonnet
 > // std.thisFile required to correctly resolve local Helm Charts
 > helm.new(std.thisFile)
 > ```


### fn helm.template

```ts
template(name, chart, conf)
```

`template` expands the Helm Chart to its underlying resources and returns them in an `Object`,
so they can be consumed and modified from within Jsonnet.

This functionality requires Helmraiser support in Jsonnet (e.g. using Grafana Tanka) and also
the `helm` binary installed on your `$PATH`.


## obj util

`util` provides common utils to modify Kubernetes objects.


### fn util.patchKubernetesObjects

```ts
patchKubernetesObjects(object, patch)
```

`patchKubernetesObjects` applies `patch` to all Kubernetes objects it finds in `object`.

### fn util.patchLabels

```ts
patchLabels(object, labels)
```

`patchLabels` finds all Kubernetes objects and adds labels to them.