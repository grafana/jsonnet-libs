Package `helm-util` allows the user to consume Helm Charts as plain Jsonnet resources.

### Usage

> **Warning:** [Functionality required](#internals) by this library is still
> experimental and may break at any time.

The [`helm.template`](#fn-helmtemplate) function to converts a Helm Chart into Jsonnet objects,
to be consumed by tools like [Grafana Tanka](https://tanka.dev).

Helm Charts are required to be available on the local file system and are
resolved relative to the file that calls `helm.template`:

```jsonnet
%s
```

### Chart Management

To simplify Chart vendoring, Tanka includes a special tool at `tk tool charts`:

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
