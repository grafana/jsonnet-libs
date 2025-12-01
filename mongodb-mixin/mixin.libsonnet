{
  grafanaDashboards+:: {
    'MongoDB_Instance.json': (import 'dashboards/MongoDB_Instance.json'),
    'MongoDB_ReplicaSet.json': (import 'dashboards/MongoDB_ReplicaSet.json'),
    'MongoDB_Cluster.json': (import 'dashboards/MongoDB_Cluster.json'),
  },
}

+ (import './alerts/mongodbAlerts.libsonnet')
+ (import './config.libsonnet')
