{
  _config+:: {
    local this = self,
    dashboardTags: ['docker'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',
    dashboardNamePrefix: '',
    //prefix
    uid: 'integration-docker',
    // ignore k8s nodes by default
    filteringSelector: 'job!="kubelet"',
    containerSelector: 'id=~"/system.slice/docker.+", name!=""',
    //signals related
    groupLabels: ['job'],
    // host level
    instanceLabels: ['instance'],
    //use cadvisor metrics by default
    metricsSource: 'cadvisor',
    signals:
      {
        container: (import './signals/container.libsonnet')(this),
        machine: (import './signals/machine.libsonnet')(this),
      },

    //logs related
    enableLokiLogs: false,
    showLogsVolume: true,
    logsVolumeGroupBy: 'container',
    // ignore logs from k8s
    logsFilteringSelector: self.filteringSelector + ', namespace="" ,container!=""',
    logsExtraFilters: |||
      | label_format timestamp="{{__timestamp__}}"
      | line_format `{{ if eq "[[instance]]" ".*" }}{{alignLeft 25 .instance}}|{{ alignLeft 25 .container }}|{{else}}{{ alignLeft 25 .container}}|{{end}} {{__line__}}`
    |||,

    logsLabels: this.groupLabels + this.instanceLabels + ['container'],
    logsFormatParser: null,

  },
}
