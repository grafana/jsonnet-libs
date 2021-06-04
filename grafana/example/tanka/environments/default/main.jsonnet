local grafana = import '../../../grafana.libsonnet';

grafana
+ grafana.withRootUrl('http://grafana.example.com')
+ grafana.withTheme('dark')
+ grafana.withAnonymous()
