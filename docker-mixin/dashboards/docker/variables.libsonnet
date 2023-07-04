local grafana = import 'grafonnet/grafana.libsonnet';
local resource = import '../../lib/resource.libsonnet';
local kind = 'Variable';

{
    ds: resource.new(kind, 'prometheus_datasource')
      + resource.withDocs('Prometheus datasources')
      + resource.withSpec({
          current: {
            text: 'default',
            value: 'default',
          },
          hide: 0,
          label: 'Data Source',
          name: 'prometheus_datasource',
          options: [],
          query: 'prometheus',
          refresh: 1,
          regex: '',
          type: 'datasource',
        },
      ),

    job: resource.new(kind, 'job')
      + resource.withDocs('Jobs available')
      + resource.withSpec(grafana.template.new(
          'job',
          '$prometheus_datasource',
          'label_values(machine_scrape_error, job)',
          label='Job',
          refresh='load',
          multi=true,
          includeAll=true,
          allValues='.+',
          sort=1,
        ),
      ),

    instance: resource.new(kind, 'instance')
      + resource.withDocs('Available instances (nodes)')
      + resource.withSpec(grafana.template.new(
          'instance',
          '$prometheus_datasource',
          'label_values(machine_scrape_error{job=~"$job"}, instance)',
          label='Instance',
          refresh='load',
          multi=true,
          includeAll=true,
          allValues='.+',
          sort=1,
        ),
      ),

    container: resource.new(kind, 'container')
      + resource.withDocs('Available containers')
      + resource.withSpec(grafana.template.new(
          'container',
          '$prometheus_datasource',
          'label_values(container_last_seen{job=~"$job", instance=~"$instance"}, name)',
          label='Container',
          refresh='load',
          multi=true,
          includeAll=true,
          allValues='.+',
          sort=1,
        ),
      ),
}
