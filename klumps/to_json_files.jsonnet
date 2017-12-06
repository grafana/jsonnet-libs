local dashboards = import "klumps.libsonnet";

{
  [name]: dashboards[name]
    for name in std.objectFields(dashboards)
}
