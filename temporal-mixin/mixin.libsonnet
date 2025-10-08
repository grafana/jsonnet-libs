local meta = import '../metadata.json';

{
  grafanaDashboards+:: {
    'temporal-overview.json': (import 'dashboards/temporal-overview.json'),
  },
}
