local grafana = import 'grafonnet/grafana.libsonnet';

{
    ds: {
      docs: 'Prometheus datasources',
        spec: {
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
    },

    job: {
      docs: 'Jobs available',
      spec: grafana.template.new(
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
    },

    instance: {
      docs: 'Available instances (nodes)',
      spec: grafana.template.new(
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
  },

  container: {
      docs: 'Available containers',
      spec: grafana.template.new(
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
  },
}
