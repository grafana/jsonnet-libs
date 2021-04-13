(import 'main.libsonnet')
+ {
  _config+:: {
    commonArgs+:: {
      'cluster-name': null,
      'admin.client.backend-type': null,
      'blocks-storage.backend': null,
    },
  },
  alertmanager+: {
    args+:: {
      'alertmanager.storage.type': null,
      'alertmanager.web.external-url': null,
    },
  },
  ruler+: {
    args+:: {
      'ruler.storage.type': null,
    },
  },
}
