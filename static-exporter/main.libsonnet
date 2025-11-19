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

  newShellExporter(name, image='gcr.io/distroless/static-debian12:debug', port=8080)::
    {
      name:: name,
      data:: {
        metrics: '',
        handler: |||
          METRICS_FILE="/data/metrics"

          handle_request() {
              local request_line
              read -r request_line

              # Parse HTTP method and path
              local method=$(echo "$request_line" | cut -d' ' -f1)
              local path=$(echo "$request_line" | cut -d' ' -f2)

              # Read and discard headers
              while IFS= read -r line && [ "$line" != $'\r' ]; do
                  :
              done

              if [[ "$path" == "/metrics" ]]; then
                  # Serve Prometheus metrics
                  echo "HTTP/1.1 200 OK"
                  echo "Connection: close"
                  echo "Content-Type: text/plain; version=0.0.4; charset=utf-8"
                  echo "Content-Length: $(wc -c < "$METRICS_FILE")"
                  echo ""
                  cat "$METRICS_FILE"
              elif [[ "$path" == "/health" ]]; then
                  # Health check endpoint
                  echo "HTTP/1.1 200 OK"
                  echo "Connection: close"
                  echo "Content-Type: text/plain"
                  echo "Content-Length: 3"
                  echo ""
                  echo "OK"
              else
                  # 404 for other paths
                  echo "HTTP/1.1 404 Not Found"
                  echo "Connection: close"
                  echo "Content-Type: text/plain"
                  echo "Content-Length: 10"
                  echo ""
                  echo "Not Found"
              fi
          }

          handle_request
        |||,
      },

      local configMap = k.core.v1.configMap,
      configmap:
        configMap.new(name, self.data),

      local container = k.core.v1.container,
      container::
        container.new('static-exporter', image)
        + container.withPorts([
          k.core.v1.containerPort.newNamed(name='http-metrics', containerPort=port),
        ])
        + k.util.resourcesRequests('10m', '10Mi')
        + container.withCommand([
          'sh',
          '-eu',
          '-c',
          |||
            # handler is created in a new file
            mkdir -p "%(bin_dir)s"
            echo '#!'$(which sh) > "%(bin_dir)s/handler"
            cat /data/handler >> "%(bin_dir)s/handler"
            chmod +x %(bin_dir)s/handler

            # run nc, which forks each handler in its own process
            exec nc -p %(port)d -l -k -e "%(bin_dir)s/handler" 0.0.0.0
          ||| % {
            port: port,
            bin_dir: '/home/nonroot/bin',
          },
        ]) +
        container.securityContext.withRunAsUser(65532) +
        container.securityContext.withRunAsGroup(65532) +
        container.readinessProbe.httpGet.withPath('/health') +
        container.readinessProbe.httpGet.withPort('http-metrics')
      ,

      local deployment = k.apps.v1.deployment,
      local volumeMount = k.core.v1.volumeMount,
      deployment:
        deployment.new(name, replicas=1, containers=[self.container]),
    },


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
      if std.objectHas(self, 'httpdConfig')
      then k.util.configMapVolumeMount(self.httpdConfig, '/usr/local/apache2/conf/httpd.conf', volumeMount.withSubPath('httpd.conf'))
      else {},
  },

  withoutHttpConfig():: {
    assert std.trace('DEPRECATION WARNING: running static-exporter without HttpConfig will make it unable for Prometheus 3.x to scrape it.', true),
    // by hiding this field, std.objectHas in the conditional above will not find the key
    httpdConfig:: super.httpdConfig,
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
