local dashboards = (import 'dashboards/integration.json').dashboards;

local dbs = dashboards {
  'docker.json'+: {
    uid:: super.uid,
  },
};

{
  grafanaDashboards: dbs
}
