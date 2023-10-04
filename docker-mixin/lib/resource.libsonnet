local docsAnnotation = 'polly.grafana.com/docs';
local apiVersion = 'grafana.com/v1alpha1';
{
  new(kind, name):: {
    apiVersion: apiVersion,
    kind: kind,
    metadata: {
        name: name,
    },
    annotations: {},
    spec: {},

    docs:: self.annotations[docsAnnotation],
  },

  withDocs(docs):: {
    annotations+: {
        [docsAnnotation]: docs,
    }
  },

  withSpec(spec):: {
    spec: spec,
  },
  
  withAnnotation(key, value):: {
    annotations+: {
      [key]: value,
    }
  },
}