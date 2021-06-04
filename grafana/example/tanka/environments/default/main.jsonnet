local grafana = import '../../../grafana.libsonnet';

grafana
+ grafana.withImage('grafana/grafana:8.0.0-beta3')
+ grafana.withRootUrl('http://grafana.example.com')
+ grafana.withTheme('dark')
+ grafana.withAnonymous()
