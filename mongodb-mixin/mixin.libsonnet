{
  grafanaDashboards: {
    'MongoDB_Instances_Compare.json': (import 'dashboards/MongoDB_Instances_Compare.json'),
    'MongoDB_Instances_Overview.json': (import 'dashboards/MongoDB_Instances_Overview.json'),
    'MongoDB_ReplSet_Summary.json': (import 'dashboards/MongoDB_ReplSet_Summary.json'),
    'MongoDB_Cluster_Summary.json': (import 'dashboards/MongoDB_Cluster_Summary.json'),
    'MongoDB_Instance_Summary.json': (import 'dashboards/MongoDB_Instance_Summary.json'),
  },

  // Helper function to ensure that we don't override other rules, by forcing
  // the patching of the groups list, and not the overall rules object.
  local importRules(rules) = {
    groups+: std.native('parseYaml')(rules)[0].groups,
  },

  prometheusAlerts+:
    importRules(importstr 'alerts/mongodbAlerts.yaml'),
}
