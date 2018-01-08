// @apiVersion 0.0.1
// @name co.kausal.pkg.prometheus
// @description Deploys a full Prometheus/Kubernetes monitoring stack.
// @shortDescription A full Prometheus/Kubernetes monitoring stack.
// @optionalParam namespace string default Namespace in which to put the application

local prometheus = import 'prometheus-ksonnet/nginx/prometheus-ksonnet.libsonnet';

local namespace = import 'param://namespace';

prometheus {
  _config+:: {
    namespace: namespace,
  }
}
