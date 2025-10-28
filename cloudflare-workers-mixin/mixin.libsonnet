local meta = import '../metadata.json';

{
  grafanaDashboards+:: {
    'cloudflare-workers.json': (import 'dashboards/cloudflare-workers.json'),
  },
}