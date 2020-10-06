Package `helm-util` allows the user to consume Helm Charts as plain Jsonnet
resources. This package implements [Helm support](https://tanka.dev/helm) for
Grafana Tanka.

### Usage

> **Warning:** [Functionality required](#internals) by this library is still experimental and may break.

The [`helm.template`](#fn-helmtemplate) function to converts a Helm Chart into Jsonnet objects,
to be consumed by tools like [Grafana Tanka](https://tanka.dev).

Helm Charts are required to be available on the local file system and are
resolved relative to the file that calls `helm.template`:

```jsonnet
%s
```

For more information on that see https://tanka.dev/helm

### Internals

The functionality of `helm-util` is based on the `helm template` command.
Because Jsonnet does not support executing arbitrary command for [good
reasons](https://jsonnet.org/ref/language.html#independence-from-the-environment-hermeticity),
a different way was required.

To work around this, [Tanka](https://tanka.dev) instead binds special
functionality into Jsonnet that provides `helm template`.

This however means this library and all libraries using this library are not
compatible with `google/go-jsonnet` or `google/jsonnet`.
