local d = import 'github.com/sh0rez/docsonnet/doc-util/main.libsonnet';
{
  local this = self,

  '#':: d.pkg(
    name='tanka-util',
    url='github.com/grafana/jsonnet-libs/tanka-util/main.libsonnet',
    help=(importstr 'README.md.tmpl') % (importstr '_example.jsonnet'),
  ),

  '#util':: d.obj(
    |||
      `util` provides common utils to modify Kubernetes objects.
    |||
  ),
  util: (import 'util.libsonnet'),

  '#helm':: d.obj(
    |||
      `helm` allows the user to consume Helm Charts as plain Jsonnet resources.
      This implements [Helm support](https://tanka.dev/helm) for Grafana Tanka.
    |||
  ),
  helm: (import 'helm.libsonnet'),
}
