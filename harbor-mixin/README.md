# Harbor Mixin

The Harbor mixin is a set of configurable Grafana dashboards and alerts.

The Harbor mixin contains the following dashboards:

- Harbor

and the following alerts:

- HarborComponentStatus
- HarborProjectQuataExceeded
- HarborHighErrorRate

## Harbor Dashboard Overview
Harbor dashbaord provides details on the overall status of the Harbor repository including the details about each project and artifcats. The dashboard includes visualizations for Harbor's Components metrics, along with key visualiozation like number of project, images, pulled images etc. 

#TODO screenshots

## Alerts Overview
- HarborComponentStatus: Status of Harbor components(Core, Registry, Database, JobService, Trivy, Notary and Redis )
- HarborProjectQuataExceeded: Harbor Porject has exceeded the assigned project quota
- HarborHighErrorRate: Harbor instance has high error rate in HTTP requests

## Tools
To use them, you need to have `mixtool` and `jsonnetfmt` installed. If you have a working Go development environment, it's easiest to run the following:

```bash
$ go get github.com/monitoring-mixins/mixtool/cmd/mixtool
$ go get github.com/google/go-jsonnet/cmd/jsonnetfmt
```

You can then build a directory `dashboard_out` with the JSON dashboard files for Grafana:

```bash
$ make build
```

For more advanced uses of mixins, see [Prometheus Monitoring Mixins docs](https://github.com/monitoring-mixins/docs).