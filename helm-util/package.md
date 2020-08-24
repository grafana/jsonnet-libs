Package `helm-util` allows to consume Helm Charts as plain Jsonnet resources.

### Usage

Use the [`helm.template`](#fn-helmtemplate) function to convert a Helm Chart into Jsonnet objects,
to be consumed by tools like [Grafana Tanka](https://tanka.dev):

```jsonnet
%s
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
