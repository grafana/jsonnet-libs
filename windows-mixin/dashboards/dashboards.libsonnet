// (import 'windows_exporter.libsonnet') +
// (import 'windows_logs.libsonnet')
local winlib = import '../lib/windows-lib/main.libsonnet';
{
    local windows = winlib.new(
        prefix="My ",
        uid="windows",
        filterSelector='job!=""',
    ),
    grafanaDashboards+::
        windows.dashboards
}