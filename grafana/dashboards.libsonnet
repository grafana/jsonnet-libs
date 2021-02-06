{
  addDashboard(name, dashboard):: {
    grafanaDashboards+:: {
      [name]: dashboard,
    },
  },
  grafanaDashboards+::{},
}
