local config = (import '../config.libsonnet');
local filterSelector = "job=~\"integrations/kafka-schemaregistry|integrations/kafka\"";
local hostSelector = config._config.HostSelector;
local jobSelector = config._config.JobSelector;
local kafkaClusterSelector = config._config.KafkaClusterSelector;

local dashboard =
  {
    "annotations": {
      "list": [
        {
          "builtIn": 1,
          "datasource": "-- Grafana --",
          "enable": true,
          "hide": true,
          "iconColor": "rgba(0, 211, 255, 1)",
          "name": "Annotations & Alerts",
          "type": "dashboard"
        }
      ]
    },
    "editable": true,
    "gnetId": null,
    "graphTooltip": 0,
    "id": 9,
    "iteration": 1623959181692,
    "links": [],
    "panels": [
      {
        "collapsed": false,
        "datasource": null,
        "gridPos": {
          "h": 1,
          "w": 24,
          "x": 0,
          "y": 0
        },
        "id": 19,
        "panels": [],
        "title": "Schemas",
        "type": "row"
      },
      {
        "datasource": "${datasource}",
        "fieldConfig": {
          "defaults": {
            "mappings": [],
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {
                  "color": "green",
                  "value": null
                },
                {
                  "color": "red",
                  "value": 80
                }
              ]
            }
          },
          "overrides": []
        },
        "gridPos": {
          "h": 10,
          "w": 4,
          "x": 0,
          "y": 1
        },
        "id": 2,
        "options": {
          "colorMode": "value",
          "graphMode": "area",
          "justifyMode": "auto",
          "orientation": "auto",
          "reduceOptions": {
            "calcs": [
              "mean"
            ],
            "fields": "",
            "values": false
          },
          "text": {},
          "textMode": "auto"
        },
        "pluginVersion": "7.5.4",
        "targets": [
          {
            "exemplar": true,
            "expr": "avg(kafka_schema_registry_registered_count{" + hostSelector + "})",
            "instant": true,
            "interval": "",
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "timeFrom": null,
        "timeShift": null,
        "title": "Schemas registered",
        "type": "stat"
      },
      {
        "aliasColors": {},
        "bars": false,
        "dashLength": 10,
        "dashes": false,
        "datasource": "${datasource}",
        "fieldConfig": {
          "defaults": {},
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 10,
          "w": 12,
          "x": 4,
          "y": 1
        },
        "hiddenSeries": false,
        "id": 11,
        "legend": {
          "alignAsTable": true,
          "avg": false,
          "current": true,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": true
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.4",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "avg by(schema_type) (kafka_schema_registry_schemas_created{" + hostSelector + "})",
            "interval": "",
            "legendFormat": "{{schema_type}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Schema registered over time",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "type": "graph",
        "xaxis": {
          "buckets": null,
          "mode": "time",
          "name": null,
          "show": true,
          "values": []
        },
        "yaxes": [
          {
            "format": "short",
            "label": null,
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          },
          {
            "format": "short",
            "label": null,
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          }
        ],
        "yaxis": {
          "align": false,
          "alignLevel": null
        }
      },
      {
        "cacheTimeout": null,
        "datasource": "${datasource}",
        "fieldConfig": {
          "defaults": {
            "color": {
              "mode": "palette-classic"
            },
            "mappings": [],
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {
                  "color": "green",
                  "value": null
                },
                {
                  "color": "red",
                  "value": 80
                }
              ]
            }
          },
          "overrides": []
        },
        "gridPos": {
          "h": 10,
          "w": 4,
          "x": 16,
          "y": 1
        },
        "id": 8,
        "interval": null,
        "links": [],
        "options": {
          "displayLabels": [],
          "legend": {
            "displayMode": "list",
            "placement": "right",
            "values": []
          },
          "pieType": "pie",
          "reduceOptions": {
            "calcs": [
              "lastNotNull"
            ],
            "fields": "",
            "values": false
          },
          "text": {}
        },
        "pluginVersion": "7.3.4",
        "targets": [
          {
            "expr": "avg by(schema_type)(kafka_schema_registry_schemas_created{" + hostSelector + "})",
            "instant": true,
            "interval": "",
            "legendFormat": "{{schema_type}}",
            "refId": "A"
          }
        ],
        "timeFrom": null,
        "timeShift": null,
        "title": "Schemas created",
        "type": "piechart"
      },
      {
        "cacheTimeout": null,
        "datasource": "${datasource}",
        "fieldConfig": {
          "defaults": {
            "color": {
              "mode": "palette-classic"
            },
            "mappings": [],
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {
                  "color": "green",
                  "value": null
                },
                {
                  "color": "red",
                  "value": 80
                }
              ]
            }
          },
          "overrides": []
        },
        "gridPos": {
          "h": 10,
          "w": 4,
          "x": 20,
          "y": 1
        },
        "id": 9,
        "interval": null,
        "links": [],
        "options": {
          "displayLabels": [],
          "legend": {
            "displayMode": "list",
            "placement": "right",
            "values": []
          },
          "pieType": "pie",
          "reduceOptions": {
            "calcs": [
              "lastNotNull"
            ],
            "fields": "",
            "values": false
          },
          "text": {}
        },
        "pluginVersion": "7.3.4",
        "targets": [
          {
            "expr": "avg by(schema_type)(kafka_schema_registry_schemas_deleted{" + hostSelector + "})",
            "instant": true,
            "interval": "",
            "legendFormat": "{{schema_type}}",
            "refId": "A"
          }
        ],
        "timeFrom": null,
        "timeShift": null,
        "title": "Schemas deleted",
        "type": "piechart"
      },
      {
        "collapsed": false,
        "datasource": null,
        "gridPos": {
          "h": 1,
          "w": 24,
          "x": 0,
          "y": 11
        },
        "id": 15,
        "panels": [],
        "title": "System",
        "type": "row"
      },
      {
        "aliasColors": {},
        "bars": false,
        "dashLength": 10,
        "dashes": false,
        "datasource": "${datasource}",
        "description": "",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 7,
          "w": 8,
          "x": 0,
          "y": 12
        },
        "hiddenSeries": false,
        "id": 13,
        "legend": {
          "alignAsTable": true,
          "avg": true,
          "current": true,
          "max": true,
          "min": false,
          "show": true,
          "total": false,
          "values": true
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.4",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "irate(process_cpu_seconds_total{" + hostSelector + "}[$__rate_interval])*100",
            "interval": "",
            "legendFormat": "{{instance}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "CPU Usage",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "type": "graph",
        "xaxis": {
          "buckets": null,
          "mode": "time",
          "name": null,
          "show": true,
          "values": []
        },
        "yaxes": [
          {
            "format": "percent",
            "label": null,
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          },
          {
            "format": "short",
            "label": null,
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          }
        ],
        "yaxis": {
          "align": false,
          "alignLevel": null
        }
      },
      {
        "aliasColors": {},
        "bars": false,
        "dashLength": 10,
        "dashes": false,
        "datasource": "${datasource}",
        "description": "",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 7,
          "w": 8,
          "x": 8,
          "y": 12
        },
        "hiddenSeries": false,
        "id": 21,
        "legend": {
          "alignAsTable": true,
          "avg": true,
          "current": true,
          "max": true,
          "min": false,
          "show": true,
          "total": false,
          "values": true
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.4",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum without(area)(jvm_memory_bytes_used{" + hostSelector + "})",
            "interval": "",
            "legendFormat": "Used:{{instance}}",
            "refId": "A"
          },
          {
            "expr": "jvm_memory_bytes_max{" + hostSelector + ",area=\"heap\"}",
            "interval": "",
            "legendFormat": "Max:{{instance}}",
            "refId": "B"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "JVM Memory Used",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "type": "graph",
        "xaxis": {
          "buckets": null,
          "mode": "time",
          "name": null,
          "show": true,
          "values": []
        },
        "yaxes": [
          {
            "format": "bytes",
            "label": null,
            "logBase": 1,
            "max": null,
            "min": "0",
            "show": true
          },
          {
            "format": "short",
            "label": null,
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          }
        ],
        "yaxis": {
          "align": false,
          "alignLevel": null
        }
      },
      {
        "aliasColors": {},
        "bars": false,
        "dashLength": 10,
        "dashes": false,
        "datasource": "${datasource}",
        "description": "",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 7,
          "w": 8,
          "x": 16,
          "y": 12
        },
        "hiddenSeries": false,
        "id": 23,
        "legend": {
          "alignAsTable": true,
          "avg": true,
          "current": true,
          "max": true,
          "min": false,
          "show": true,
          "total": false,
          "values": true
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.4",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum without(gc)(rate(jvm_gc_collection_seconds_sum{" + hostSelector + "}[$__rate_interval]))",
            "interval": "",
            "legendFormat": "{{instance}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Time spent in GC",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "type": "graph",
        "xaxis": {
          "buckets": null,
          "mode": "time",
          "name": null,
          "show": true,
          "values": []
        },
        "yaxes": [
          {
            "decimals": 3,
            "format": "percentunit",
            "label": null,
            "logBase": 1,
            "max": null,
            "min": "0",
            "show": true
          },
          {
            "format": "short",
            "label": null,
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          }
        ],
        "yaxis": {
          "align": false,
          "alignLevel": null
        }
      },
      {
        "datasource": null,
        "gridPos": {
          "h": 1,
          "w": 24,
          "x": 0,
          "y": 19
        },
        "id": 17,
        "title": "Connections",
        "type": "row"
      },
      {
        "aliasColors": {},
        "bars": false,
        "dashLength": 10,
        "dashes": false,
        "datasource": "${datasource}",
        "fieldConfig": {
          "defaults": {},
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 8,
          "x": 0,
          "y": 20
        },
        "hiddenSeries": false,
        "id": 4,
        "legend": {
          "alignAsTable": true,
          "avg": true,
          "current": true,
          "max": true,
          "min": false,
          "show": true,
          "total": false,
          "values": true
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.4",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_schema_registry_jetty_metrics_connections_active{" + hostSelector + "}",
            "interval": "",
            "legendFormat": "{{instance}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Active Connections",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "type": "graph",
        "xaxis": {
          "buckets": null,
          "mode": "time",
          "name": null,
          "show": true,
          "values": []
        },
        "yaxes": [
          {
            "format": "short",
            "label": null,
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          },
          {
            "format": "short",
            "label": null,
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          }
        ],
        "yaxis": {
          "align": false,
          "alignLevel": null
        }
      },
      {
        "aliasColors": {},
        "bars": false,
        "dashLength": 10,
        "dashes": false,
        "datasource": "${datasource}",
        "fieldConfig": {
          "defaults": {},
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 8,
          "x": 8,
          "y": 20
        },
        "hiddenSeries": false,
        "id": 6,
        "legend": {
          "alignAsTable": true,
          "avg": true,
          "current": true,
          "max": true,
          "min": false,
          "show": true,
          "total": false,
          "values": true
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.4",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_schema_registry_jersey_metrics_request_rate{" + hostSelector + "}",
            "interval": "",
            "legendFormat": "{{instance}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Requests Rate",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "type": "graph",
        "xaxis": {
          "buckets": null,
          "mode": "time",
          "name": null,
          "show": true,
          "values": []
        },
        "yaxes": [
          {
            "format": "short",
            "label": null,
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          },
          {
            "format": "short",
            "label": null,
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          }
        ],
        "yaxis": {
          "align": false,
          "alignLevel": null
        }
      },
      {
        "aliasColors": {},
        "bars": false,
        "dashLength": 10,
        "dashes": false,
        "datasource": "${datasource}",
        "fieldConfig": {
          "defaults": {},
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 8,
          "x": 16,
          "y": 20
        },
        "hiddenSeries": false,
        "id": 24,
        "legend": {
          "alignAsTable": true,
          "avg": true,
          "current": true,
          "max": true,
          "min": false,
          "show": true,
          "total": false,
          "values": true
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.4",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_schema_registry_jersey_metrics_request_latency_99{" + hostSelector + "}",
            "interval": "",
            "legendFormat": "{{instance}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Requests latency 99p",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "type": "graph",
        "xaxis": {
          "buckets": null,
          "mode": "time",
          "name": null,
          "show": true,
          "values": []
        },
        "yaxes": [
          {
            "format": "short",
            "label": null,
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          },
          {
            "format": "short",
            "label": null,
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          }
        ],
        "yaxis": {
          "align": false,
          "alignLevel": null
        }
      }
    ],
    "refresh": "1m",
    "schemaVersion": 27,
    "style": "dark",
    "tags": [],
    "templating": {
      "list": [
        {
          "current": {
            "selected": false,
            "text": "Prometheus",
            "value": "Prometheus"
          },
          "description": null,
          "error": null,
          "hide": 0,
          "includeAll": false,
          "label": "Data source",
          "multi": false,
          "name": "datasource",
          "options": [],
          "query": "prometheus",
          "refresh": 1,
          "regex": "",
          "skipUrlSync": false,
          "type": "datasource"
        },
        {
          "allValue": ".+",
          "current": {},
          "datasource": "$datasource",
          "definition": "label_values(kafka_schema_registry_registered_count{" + filterSelector + "}, job)",
          "description": null,
          "error": null,
          "hide": 0,
          "includeAll": true,
          "label": "Job",
          "multi": true,
          "name": "job",
          "options": [],
          "query": {
            "query": "label_values(kafka_schema_registry_registered_count{" + filterSelector + "}, job)",
            "refId": "StandardVariableQuery"
          },
          "refresh": 2,
          "regex": "",
          "skipUrlSync": false,
          "sort": 0,
          "tagValuesQuery": "",
          "tags": [],
          "tagsQuery": "",
          "type": "query",
          "useTags": false
        },
        {
          "allValue": ".+",
          "current": {},
          "datasource": "${datasource}",
          "definition": "label_values(kafka_schema_registry_registered_count{" + jobSelector + "}, kafka_cluster)",
          "description": null,
          "error": null,
          "hide": 0,
          "includeAll": true,
          "label": "Kafka Cluster",
          "multi": true,
          "name": "kafka_cluster",
          "options": [],
          "query": {
            "query": "label_values(kafka_schema_registry_registered_count{" + jobSelector + "}, kafka_cluster)",
            "refId": "StandardVariableQuery"
          },
          "refresh": 2,
          "regex": "",
          "skipUrlSync": false,
          "sort": 0,
          "tagValuesQuery": "",
          "tags": [],
          "tagsQuery": "",
          "type": "query",
          "useTags": false
        },
        {
          "allValue": ".+",
          "current": {},
          "datasource": "${datasource}",
          "definition": "label_values(kafka_schema_registry_registered_count{" + jobSelector + ", " + kafkaClusterSelector + "},instance)",
          "description": null,
          "error": null,
          "hide": 0,
          "includeAll": true,
          "label": "Instance",
          "multi": true,
          "name": "instance",
          "options": [],
          "query": {
            "query": "label_values(kafka_schema_registry_registered_count{" + jobSelector + ", " + kafkaClusterSelector + "},instance)",
            "refId": "StandardVariableQuery"
          },
          "refresh": 2,
          "regex": "",
          "skipUrlSync": false,
          "sort": 0,
          "tagValuesQuery": "",
          "tags": [],
          "tagsQuery": "",
          "type": "query",
          "useTags": false
        }
      ]
    },
    "time": {
      "from": "now-5m",
      "to": "now"
    },
    "timepicker": {},
    "timezone": "",
    "title": "Schema Registry Overview",
    "uid": "9ixzve-Mk",
    "version": 3
  };

{
  grafanaDashboards+::
  {
    'schema-registry-overview.json': dashboard
  }
}
