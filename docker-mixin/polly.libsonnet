local config = import 'config.libsonnet';
local docker = import 'dashboards/docker/main.libsonnet';
local dockerLogs = import 'dashboards/docker-logs/main.libsonnet';
{
    queries:
        docker.queries(config)
        + dockerLogs.queries(config),
    variables:
        docker.variables(config)
        + dockerLogs.variables(config),
    targets:
        docker.targets(config)
        + dockerLogs.targets(config),
    panels:
        docker.panels(config)
        + dockerLogs.panels(config),
    dashboards:
        docker.dashboards(config)
        + dockerLogs.dashboards(config),
}
