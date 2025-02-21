local k = import 'ksonnet-util/kausal.libsonnet';

{
  new(name, image='httpd:2.4-alpine')::
    {
      name:: name,
      data:: { metrics: '' },

      local configMap = k.core.v1.configMap,
      configmap:
        configMap.new(name, self.data),

      local container = k.core.v1.container,
      container::
        container.new('static-exporter', image)
        + container.withPorts([
          k.core.v1.containerPort.newNamed(name='http-metrics', containerPort=80),
        ])
        + k.util.resourcesRequests('10m', '10Mi')
      ,

      local deployment = k.apps.v1.deployment,
      local volumeMount = k.core.v1.volumeMount,
      deployment:
        deployment.new(name, replicas=1, containers=[self.container])
        + k.util.configMapVolumeMount(self.configmap, '/usr/local/apache2/htdocs'),
    }
    + self.withHttpConfig()
  ,

  withData(data):: { data: data },

  withDataMixin(data):: { data+: data },

  withMetrics(metrics)::
    self.withDataMixin({
      metrics:
        std.lines(
          std.foldl(
            function(acc, metric)
              acc + [
                '# HELP %(name)s %(description)s' % metric,
                '# TYPE %(name)s counter' % metric,
              ] + [
                metric.name + value
                for value in metric.values
              ],
            metrics,
            []
          )
        ),
    }),

  withHttpConfig(config=(importstr 'httpd.conf')):: {
    local configMap = k.core.v1.configMap,
    local volumeMount = k.core.v1.volumeMount,
    httpdConfig:
      configMap.new(self.name + '-httpd-config')
      + configMap.withData({
        'httpd.conf': config,
      }),
    deployment+:
      k.util.configMapVolumeMount(self.httpdConfig, '/usr/local/apache2/conf/httpd.conf', volumeMount.withSubPath('httpd.conf')),
  },

  withoutHttpConfig():: {
    assert std.trace('DEPRECATION WARNING: running static-exporter without HttpConfig will make it unable for Prometheus 3.x to scrape it.', true),
    local name = self.name + '-httpd-config',
    httpdConfig:: super.httpdConfig,
    deployment+: {
      spec+: {
        template+: {
          spec+: {
            containers:
              std.map(
                function(container)
                  container + {
                    volumeMounts:
                      std.filter(
                        function(volumeMount)
                          volumeMount.name != name,
                        container.volumeMounts
                      ),
                  },
                super.containers
              ),
            volumes:
              std.filter(
                function(volume)
                  volume.name != name,
                super.volumes
              ),
          },
        },
      },
    },
  },

  metric:: {
    new(name, description)::
      self.withName(name)
      + self.withDescription(description),

    withName(name): { name: name },

    withDescription(description): { description: description },

    local generateValues(labelMap, value=1, valueAsFloat=false) =
      local labels = [
        key + '="' + labelMap[key] + '"'
        for key in std.objectFields(labelMap)
      ];
      [
        (
          if valueAsFloat
          then '{%s} %f'
          else '{%s} %d'
        ) % [std.join(',', labels), value],
      ],

    // withValue adds a labeled metric with a value
    // labelMap = { key: value }
    withValue(labelMap, value=1, valueAsFloat=false): {
      values+: generateValues(labelMap, value, valueAsFloat),
    },

    // withLabelMapList adds multiple labeled metrics with the same value
    // labelMapList = [labelMap1, labelMap2]
    withLabelMapList(labelMapList, value=1):: {
      values+: std.foldr(
        function(data, acc)
          acc + generateValues(data, value),
        labelMapList,
        []
      ),
    },
  },
}
