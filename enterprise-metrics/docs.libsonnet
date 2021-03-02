(import 'main.libsonnet')
+ {
  _config+:: {
    commonArgs+:: {
      'cluster-name': null,
      'admin.client.backend-type': null,
      'blocks-storage.backend': null,
    },
  },
}
