local config = (import '../config.libsonnet');
local filterSelector = "job=~\"integrations/kafka*\"";
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
    "description": "Kafka resource usage and throughput",
    "editable": false,
    "gnetId": 721,
    "graphTooltip": 0,
    "id": 5,
    "iteration": 1624298233560,
    "links": [],
    "panels": [
      {
        "collapsed": false,
        "datasource": "$datasource",
        "gridPos": {
          "h": 1,
          "w": 24,
          "x": 0,
          "y": 0
        },
        "id": 42,
        "panels": [],
        "title": "Healthcheck",
        "type": "row"
      },
      {
        "cacheTimeout": null,
        "datasource": "${datasource}",
        "description": "Number of active controllers in the cluster.",
        "fieldConfig": {
          "defaults": {
            "mappings": [
              {
                "id": 0,
                "op": "=",
                "text": "N/A",
                "type": 1,
                "value": "null"
              }
            ],
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {
                  "color": "#299c46",
                  "value": null
                },
                {
                  "color": "#e5ac0e",
                  "value": 2
                },
                {
                  "color": "#bf1b00"
                }
              ]
            },
            "unit": "none"
          },
          "overrides": []
        },
        "gridPos": {
          "h": 4,
          "w": 4,
          "x": 0,
          "y": 1
        },
        "id": 12,
        "interval": null,
        "links": [],
        "maxDataPoints": 100,
        "options": {
          "colorMode": "value",
          "fieldOptions": {
            "calcs": [
              "lastNotNull"
            ]
          },
          "graphMode": "none",
          "justifyMode": "auto",
          "orientation": "horizontal",
          "reduceOptions": {
            "calcs": [
              "last"
            ],
            "fields": "",
            "values": false
          },
          "text": {},
          "textMode": "auto"
        },
        "pluginVersion": "7.5.6",
        "targets": [
          {
            "expr": "sum(kafka_controller_kafkacontroller_activecontrollercount{" + hostSelector + "})",
            "format": "time_series",
            "intervalFactor": 1,
            "refId": "A"
          }
        ],
        "timeFrom": null,
        "timeShift": null,
        "title": "Active Controllers",
        "type": "stat"
      },
      {
        "cacheTimeout": null,
        "datasource": "${datasource}",
        "description": "Number of Brokers Online",
        "fieldConfig": {
          "defaults": {
            "mappings": [
              {
                "id": 0,
                "op": "=",
                "text": "N/A",
                "type": 1,
                "value": "null"
              }
            ],
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {
                  "color": "#d44a3a",
                  "value": null
                },
                {
                  "color": "rgba(237, 129, 40, 0.89)",
                  "value": 0
                },
                {
                  "color": "semi-dark-green",
                  "value": 2
                }
              ]
            },
            "unit": "none"
          },
          "overrides": []
        },
        "gridPos": {
          "h": 4,
          "w": 4,
          "x": 4,
          "y": 1
        },
        "id": 14,
        "interval": null,
        "links": [],
        "maxDataPoints": 100,
        "options": {
          "colorMode": "value",
          "fieldOptions": {
            "calcs": [
              "lastNotNull"
            ]
          },
          "graphMode": "none",
          "justifyMode": "auto",
          "orientation": "horizontal",
          "reduceOptions": {
            "calcs": [
              "last"
            ],
            "fields": "",
            "values": false
          },
          "text": {},
          "textMode": "auto"
        },
        "pluginVersion": "7.5.6",
        "repeat": null,
        "repeatDirection": "h",
        "targets": [
          {
            "expr": "count(kafka_server_replicamanager_leadercount{" + hostSelector + "})",
            "format": "time_series",
            "intervalFactor": 1,
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "title": "Brokers Online",
        "type": "stat"
      },
      {
        "cacheTimeout": null,
        "datasource": "${datasource}",
        "description": "Unclean leader election rate",
        "fieldConfig": {
          "defaults": {
            "mappings": [
              {
                "id": 0,
                "op": "=",
                "text": "N/A",
                "type": 1,
                "value": "null"
              }
            ],
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {
                  "color": "#299c46",
                  "value": null
                },
                {
                  "color": "rgba(237, 129, 40, 0.89)",
                  "value": 1
                },
                {
                  "color": "#d44a3a"
                }
              ]
            },
            "unit": "none"
          },
          "overrides": []
        },
        "gridPos": {
          "h": 4,
          "w": 4,
          "x": 8,
          "y": 1
        },
        "id": 16,
        "interval": null,
        "links": [],
        "maxDataPoints": 100,
        "options": {
          "colorMode": "value",
          "fieldOptions": {
            "calcs": [
              "lastNotNull"
            ]
          },
          "graphMode": "none",
          "justifyMode": "auto",
          "orientation": "horizontal",
          "reduceOptions": {
            "calcs": [
              "last"
            ],
            "fields": "",
            "values": false
          },
          "text": {},
          "textMode": "auto"
        },
        "pluginVersion": "7.5.6",
        "targets": [
          {
            "expr": "sum(kafka_controller_controllerstats_uncleanleaderelectionspersec{" + hostSelector + "})",
            "format": "time_series",
            "intervalFactor": 1,
            "refId": "A"
          }
        ],
        "title": "Unclean Leader Election Rate",
        "type": "stat"
      },
      {
        "cacheTimeout": null,
        "datasource": "${datasource}",
        "description": "",
        "fieldConfig": {
          "defaults": {
            "mappings": [
              {
                "id": 0,
                "op": "=",
                "text": "N/A",
                "type": 1,
                "value": "null"
              }
            ],
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {
                  "color": "#299c46",
                  "value": null
                },
                {
                  "color": "rgba(237, 129, 40, 0.89)",
                  "value": 2
                },
                {
                  "color": "#d44a3a"
                }
              ]
            },
            "unit": "none"
          },
          "overrides": []
        },
        "gridPos": {
          "h": 4,
          "w": 4,
          "x": 12,
          "y": 1
        },
        "id": 33,
        "interval": null,
        "links": [],
        "maxDataPoints": 100,
        "options": {
          "colorMode": "value",
          "fieldOptions": {
            "calcs": [
              "lastNotNull"
            ]
          },
          "graphMode": "none",
          "justifyMode": "auto",
          "orientation": "horizontal",
          "reduceOptions": {
            "calcs": [
              "last"
            ],
            "fields": "",
            "values": false
          },
          "text": {},
          "textMode": "auto"
        },
        "pluginVersion": "7.5.6",
        "targets": [
          {
            "expr": "sum(kafka_controller_kafkacontroller_preferredreplicaimbalancecount{" + hostSelector + "})",
            "format": "time_series",
            "intervalFactor": 1,
            "refId": "A"
          }
        ],
        "title": "Preferred Replica Imbalance",
        "type": "stat"
      },
      {
        "aliasColors": {},
        "bars": false,
        "dashLength": 10,
        "dashes": false,
        "datasource": "${datasource}",
        "editable": true,
        "error": false,
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "grid": {},
        "gridPos": {
          "h": 8,
          "w": 8,
          "x": 16,
          "y": 1
        },
        "hiddenSeries": false,
        "id": 84,
        "isNew": true,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 2,
        "links": [],
        "nullPointMode": "connected",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 5,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum(rate(kafka_server_brokertopicmetrics_bytesinpersec{" + hostSelector + ",topic!=\"\"}[$__rate_interval]))",
            "format": "time_series",
            "intervalFactor": 2,
            "legendFormat": "Bytes in",
            "metric": "kafka_server_brokertopicmetrics_bytesinpersec",
            "refId": "A",
            "step": 4
          },
          {
            "expr": "sum(rate(kafka_server_brokertopicmetrics_bytesoutpersec{" + hostSelector + ",topic!=\"\"}[$__rate_interval]))",
            "format": "time_series",
            "hide": false,
            "interval": "",
            "intervalFactor": 2,
            "legendFormat": "Bytes out",
            "metric": "kafka_server_brokertopicmetrics_bytesinpersec",
            "refId": "B",
            "step": 4
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Broker network throughput",
        "tooltip": {
          "msResolution": false,
          "shared": true,
          "sort": 2,
          "value_type": "cumulative"
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
            "format": "Bps",
            "label": "Bytes/s",
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
        "description": "Number of partitions that dont have an active leader and are hence not writable or readable.",
        "fieldConfig": {
          "defaults": {
            "mappings": [
              {
                "id": 0,
                "op": "=",
                "text": "N/A",
                "type": 1,
                "value": "null"
              }
            ],
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {
                  "color": "semi-dark-green",
                  "value": null
                },
                {
                  "color": "#bf1b00",
                  "value": 1
                }
              ]
            },
            "unit": "none"
          },
          "overrides": []
        },
        "gridPos": {
          "h": 4,
          "w": 4,
          "x": 0,
          "y": 5
        },
        "id": 22,
        "interval": null,
        "links": [],
        "maxDataPoints": 100,
        "options": {
          "colorMode": "value",
          "fieldOptions": {
            "calcs": [
              "lastNotNull"
            ]
          },
          "graphMode": "none",
          "justifyMode": "auto",
          "orientation": "horizontal",
          "reduceOptions": {
            "calcs": [
              "last"
            ],
            "fields": "",
            "values": false
          },
          "text": {},
          "textMode": "auto"
        },
        "pluginVersion": "7.5.6",
        "targets": [
          {
            "expr": "sum(kafka_controller_kafkacontroller_offlinepartitionscount{" + hostSelector + "})",
            "format": "time_series",
            "interval": "",
            "intervalFactor": 1,
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "title": "Offline Partitions Count",
        "type": "stat"
      },
      {
        "cacheTimeout": null,
        "datasource": "${datasource}",
        "description": "Number of under-replicated partitions (| ISR | < | all replicas |).",
        "fieldConfig": {
          "defaults": {
            "mappings": [
              {
                "id": 0,
                "op": "=",
                "text": "N/A",
                "type": 1,
                "value": "null"
              }
            ],
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {
                  "color": "semi-dark-green",
                  "value": null
                },
                {
                  "color": "rgba(237, 129, 40, 0.89)",
                  "value": 1
                },
                {
                  "color": "#bf1b00",
                  "value": 5
                }
              ]
            },
            "unit": "none"
          },
          "overrides": []
        },
        "gridPos": {
          "h": 4,
          "w": 4,
          "x": 4,
          "y": 5
        },
        "id": 20,
        "interval": null,
        "links": [],
        "maxDataPoints": 100,
        "options": {
          "colorMode": "value",
          "fieldOptions": {
            "calcs": [
              "lastNotNull"
            ]
          },
          "graphMode": "none",
          "justifyMode": "auto",
          "orientation": "horizontal",
          "reduceOptions": {
            "calcs": [
              "last"
            ],
            "fields": "",
            "values": false
          },
          "text": {},
          "textMode": "auto"
        },
        "pluginVersion": "7.5.6",
        "targets": [
          {
            "expr": "sum(kafka_server_replicamanager_underreplicatedpartitions{" + hostSelector + "})",
            "format": "time_series",
            "hide": false,
            "intervalFactor": 2,
            "refId": "A"
          }
        ],
        "title": "Under Replicated Partitions",
        "type": "stat"
      },
      {
        "cacheTimeout": null,
        "datasource": "${datasource}",
        "description": "Number of partitions under min insync replicas.",
        "fieldConfig": {
          "defaults": {
            "mappings": [
              {
                "id": 0,
                "op": "=",
                "text": "N/A",
                "type": 1,
                "value": "null"
              }
            ],
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {
                  "color": "semi-dark-green",
                  "value": null
                },
                {
                  "color": "#bf1b00",
                  "value": 1
                }
              ]
            },
            "unit": "none"
          },
          "overrides": []
        },
        "gridPos": {
          "h": 4,
          "w": 4,
          "x": 8,
          "y": 5
        },
        "id": 32,
        "interval": null,
        "links": [],
        "maxDataPoints": 100,
        "options": {
          "colorMode": "value",
          "fieldOptions": {
            "calcs": [
              "lastNotNull"
            ]
          },
          "graphMode": "none",
          "justifyMode": "auto",
          "orientation": "horizontal",
          "reduceOptions": {
            "calcs": [
              "last"
            ],
            "fields": "",
            "values": false
          },
          "text": {},
          "textMode": "auto"
        },
        "pluginVersion": "7.5.6",
        "targets": [
          {
            "expr": "sum(kafka_cluster_partition_underminisr{" + hostSelector + "})",
            "format": "time_series",
            "hide": false,
            "interval": "",
            "intervalFactor": 2,
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "title": "Under Min ISR Partitions",
        "type": "stat"
      },
      {
        "cacheTimeout": null,
        "datasource": "${datasource}",
        "description": "Partitions that are online",
        "fieldConfig": {
          "defaults": {
            "mappings": [
              {
                "id": 0,
                "op": "=",
                "text": "N/A",
                "type": 1,
                "value": "null"
              }
            ],
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {
                  "color": "#d44a3a",
                  "value": null
                },
                {
                  "color": "rgba(237, 129, 40, 0.89)",
                  "value": 0
                },
                {
                  "color": "#299c46",
                  "value": 0
                }
              ]
            },
            "unit": "none"
          },
          "overrides": []
        },
        "gridPos": {
          "h": 4,
          "w": 4,
          "x": 12,
          "y": 5
        },
        "id": 18,
        "interval": null,
        "links": [],
        "maxDataPoints": 100,
        "options": {
          "colorMode": "value",
          "fieldOptions": {
            "calcs": [
              "lastNotNull"
            ]
          },
          "graphMode": "none",
          "justifyMode": "auto",
          "orientation": "horizontal",
          "reduceOptions": {
            "calcs": [
              "last"
            ],
            "fields": "",
            "values": false
          },
          "text": {},
          "textMode": "auto"
        },
        "pluginVersion": "7.5.6",
        "targets": [
          {
            "expr": "sum(kafka_server_replicamanager_partitioncount{" + hostSelector + "})",
            "format": "time_series",
            "interval": "",
            "intervalFactor": 1,
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "title": "Online Partitions",
        "type": "stat"
      },
      {
        "collapsed": false,
        "datasource": "$datasource",
        "gridPos": {
          "h": 1,
          "w": 24,
          "x": 0,
          "y": 9
        },
        "id": 40,
        "panels": [],
        "title": "System",
        "type": "row"
      },
      {
        "aliasColors": {
          "localhost:7071": "#629E51"
        },
        "bars": false,
        "dashLength": 10,
        "dashes": false,
        "datasource": "${datasource}",
        "editable": true,
        "error": false,
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "grid": {},
        "gridPos": {
          "h": 7,
          "w": 8,
          "x": 0,
          "y": 10
        },
        "hiddenSeries": false,
        "id": 27,
        "isNew": true,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 2,
        "links": [],
        "nullPointMode": "connected",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 5,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "irate(process_cpu_seconds_total{" + hostSelector + "}[$__rate_interval])*100",
            "format": "time_series",
            "intervalFactor": 2,
            "legendFormat": "{{instance}}",
            "metric": "process_cpu_secondspersec",
            "refId": "A",
            "step": 4
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "CPU Usage",
        "tooltip": {
          "msResolution": false,
          "shared": true,
          "sort": 2,
          "value_type": "cumulative"
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
            "label": "Cores",
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
        "aliasColors": {
          "localhost:7071": "#BA43A9"
        },
        "bars": false,
        "dashLength": 10,
        "dashes": false,
        "datasource": "${datasource}",
        "editable": true,
        "error": false,
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "grid": {},
        "gridPos": {
          "h": 7,
          "w": 8,
          "x": 8,
          "y": 10
        },
        "hiddenSeries": false,
        "id": 2,
        "isNew": true,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 2,
        "links": [],
        "nullPointMode": "connected",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 5,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum without(area)(jvm_memory_bytes_used{" + hostSelector + "})",
            "intervalFactor": 2,
            "legendFormat": "{{instance}}",
            "metric": "jvm_memory_bytes_used",
            "refId": "A",
            "step": 4
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "JVM Memory Used",
        "tooltip": {
          "msResolution": false,
          "shared": true,
          "sort": 2,
          "value_type": "cumulative"
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
            "label": "Memory",
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
        "aliasColors": {
          "localhost:7071": "#890F02"
        },
        "bars": false,
        "dashLength": 10,
        "dashes": false,
        "datasource": "${datasource}",
        "editable": true,
        "error": false,
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "grid": {},
        "gridPos": {
          "h": 7,
          "w": 8,
          "x": 16,
          "y": 10
        },
        "hiddenSeries": false,
        "id": 3,
        "isNew": true,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 2,
        "links": [],
        "nullPointMode": "connected",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 5,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum without(gc)(rate(jvm_gc_collection_seconds_sum{" + hostSelector + "}[$__rate_interval]))",
            "intervalFactor": 2,
            "legendFormat": "{{instance}}",
            "metric": "jvm_gc_collection_seconds_sum",
            "refId": "A",
            "step": 4
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Time spent in GC",
        "tooltip": {
          "msResolution": false,
          "shared": true,
          "sort": 2,
          "value_type": "cumulative"
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
            "format": "percentunit",
            "label": "% time in GC",
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
        "collapsed": false,
        "datasource": "$datasource",
        "gridPos": {
          "h": 1,
          "w": 24,
          "x": 0,
          "y": 17
        },
        "id": 29,
        "panels": [],
        "title": "Throughput In/Out",
        "type": "row"
      },
      {
        "aliasColors": {},
        "bars": false,
        "dashLength": 10,
        "dashes": false,
        "datasource": "${datasource}",
        "editable": true,
        "error": false,
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "grid": {},
        "gridPos": {
          "h": 7,
          "w": 8,
          "x": 0,
          "y": 18
        },
        "hiddenSeries": false,
        "id": 4,
        "isNew": true,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 2,
        "links": [],
        "nullPointMode": "connected",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 5,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum without(instance)(rate(kafka_server_brokertopicmetrics_messagesinpersec{" + hostSelector + ",topic=~\"$topic\"}[$__rate_interval]))",
            "interval": "",
            "intervalFactor": 2,
            "legendFormat": "{{topic}}",
            "metric": "kafka_server_brokertopicmetrics_messagesinpersec",
            "refId": "A",
            "step": 4
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Messages In Per Topic",
        "tooltip": {
          "msResolution": false,
          "shared": true,
          "sort": 2,
          "value_type": "cumulative"
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
            "format": "iops",
            "label": "Messages/s",
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
        "editable": true,
        "error": false,
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "grid": {},
        "gridPos": {
          "h": 7,
          "w": 8,
          "x": 8,
          "y": 18
        },
        "hiddenSeries": false,
        "id": 5,
        "isNew": true,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 2,
        "links": [],
        "nullPointMode": "connected",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 5,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum without(instance)(rate(kafka_server_brokertopicmetrics_bytesinpersec{" + hostSelector + ",topic=~\"$topic\"}[$__rate_interval]))",
            "format": "time_series",
            "interval": "",
            "intervalFactor": 2,
            "legendFormat": "{{topic}}",
            "metric": "kafka_server_brokertopicmetrics_bytesinpersec",
            "refId": "A",
            "step": 4
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Bytes In Per Topic",
        "tooltip": {
          "msResolution": false,
          "shared": true,
          "sort": 2,
          "value_type": "cumulative"
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
            "format": "Bps",
            "label": "Bytes/s",
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
        "editable": true,
        "error": false,
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "grid": {},
        "gridPos": {
          "h": 7,
          "w": 8,
          "x": 16,
          "y": 18
        },
        "hiddenSeries": false,
        "id": 6,
        "isNew": true,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 2,
        "links": [],
        "nullPointMode": "connected",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 5,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum without(instance)(rate(kafka_server_brokertopicmetrics_bytesoutpersec{" + hostSelector + ",topic=~\"$topic\"}[$__rate_interval]))",
            "interval": "",
            "intervalFactor": 2,
            "legendFormat": "{{topic}}",
            "metric": "kafka_server_brokertopicmetrics_bytesinpersec",
            "refId": "A",
            "step": 4
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Bytes Out Per Topic",
        "tooltip": {
          "msResolution": false,
          "shared": true,
          "sort": 2,
          "value_type": "cumulative"
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
            "format": "Bps",
            "label": "Bytes/s",
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
        "editable": true,
        "error": false,
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "grid": {},
        "gridPos": {
          "h": 7,
          "w": 8,
          "x": 0,
          "y": 25
        },
        "hiddenSeries": false,
        "id": 10,
        "isNew": true,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 2,
        "links": [],
        "nullPointMode": "connected",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 5,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum without(topic)(rate(kafka_server_brokertopicmetrics_messagesinpersec{" + hostSelector + ",topic=~\"$topic\"}[$__rate_interval]))",
            "format": "time_series",
            "interval": "",
            "intervalFactor": 2,
            "legendFormat": "{{instance}}",
            "metric": "kafka_server_brokertopicmetrics_messagesinpersec",
            "refId": "A",
            "step": 4
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Messages In Per Broker",
        "tooltip": {
          "msResolution": false,
          "shared": true,
          "sort": 2,
          "value_type": "cumulative"
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
            "format": "iops",
            "label": "Messages/s",
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
        "editable": true,
        "error": false,
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "grid": {},
        "gridPos": {
          "h": 7,
          "w": 8,
          "x": 8,
          "y": 25
        },
        "hiddenSeries": false,
        "id": 7,
        "isNew": true,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 2,
        "links": [],
        "nullPointMode": "connected",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 5,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum without(topic)(rate(kafka_server_brokertopicmetrics_bytesinpersec{" + hostSelector + ",topic=~\"$topic\"}[$__rate_interval]))",
            "format": "time_series",
            "interval": "",
            "intervalFactor": 2,
            "legendFormat": "{{instance}}",
            "metric": "kafka_server_brokertopicmetrics_bytesinpersec",
            "refId": "A",
            "step": 4
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Bytes In Per Broker",
        "tooltip": {
          "msResolution": false,
          "shared": true,
          "sort": 2,
          "value_type": "cumulative"
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
            "format": "Bps",
            "label": "Bytes/s",
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
          "y": 25
        },
        "hiddenSeries": false,
        "id": 9,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "links": [],
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 5,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum without(topic)(rate(kafka_server_brokertopicmetrics_bytesoutpersec{" + hostSelector + ",topic=~\"$topic\"}[$__rate_interval]))",
            "format": "time_series",
            "interval": "",
            "intervalFactor": 1,
            "legendFormat": "{{instance}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Bytes Out Per Broker",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
        "collapsed": false,
        "datasource": "$datasource",
        "gridPos": {
          "h": 1,
          "w": 24,
          "x": 0,
          "y": 32
        },
        "id": 117,
        "panels": [],
        "title": "Replication",
        "type": "row"
      },
      {
        "aliasColors": {},
        "bars": false,
        "dashLength": 10,
        "dashes": false,
        "datasource": "$datasource",
        "description": "Offline partitions over time",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 33
        },
        "hiddenSeries": false,
        "id": 122,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum(kafka_server_replicamanager_partitioncount{" + hostSelector + "})",
            "interval": "",
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Online Partitions",
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
        "datasource": "$datasource",
        "description": "Offline partitions over time",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 33
        },
        "hiddenSeries": false,
        "id": 121,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum(kafka_controller_kafkacontroller_offlinepartitionscount{" + hostSelector + "})",
            "interval": "",
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Offline Partitions",
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
        "datasource": "$datasource",
        "description": "Under replicated partitions over time",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 41
        },
        "hiddenSeries": false,
        "id": 120,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum(kafka_cluster_partition_underreplicated{" + hostSelector + "})",
            "interval": "",
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Under Replicated Partitions",
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
        "datasource": "$datasource",
        "description": "Under min in sync replicas partitions over time",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 41
        },
        "hiddenSeries": false,
        "id": 119,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum(kafka_cluster_partition_underminisr{" + hostSelector + "})",
            "interval": "",
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Under Min ISR Partitions",
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
        "collapsed": false,
        "datasource": "$datasource",
        "gridPos": {
          "h": 1,
          "w": 24,
          "x": 0,
          "y": 49
        },
        "id": 44,
        "panels": [],
        "title": "Thread utilization",
        "type": "row"
      },
      {
        "aliasColors": {},
        "bars": false,
        "dashLength": 10,
        "dashes": false,
        "datasource": "$datasource",
        "description": "Average fraction of time the network processor threads are idle. Values are between 0 (all resources are used) and 100 (all resources are available) ",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 50
        },
        "hiddenSeries": false,
        "id": 24,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_network_socketserver_networkprocessoravgidlepercent{" + hostSelector + "}",
            "legendFormat": "{{instance}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Network Processor Avg Idle Percent",
        "tooltip": {
          "shared": true,
          "sort": 1,
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
            "format": "percentunit",
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
        "datasource": "$datasource",
        "description": "Average fraction of time the request handler threads are idle. Values are between 0 (all resources are used) and 100 (all resources are available). ",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 50
        },
        "hiddenSeries": false,
        "id": 25,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_server_kafkarequesthandlerpool_requesthandleravgidlepercent_total{" + hostSelector + "}",
            "legendFormat": "{{instance}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Request Handler Avg Idle Percent",
        "tooltip": {
          "shared": true,
          "sort": 1,
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
            "format": "percentunit",
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
        "datasource": "$datasource",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 58
        },
        "hiddenSeries": false,
        "id": 126,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_network_requestchannel_requestqueuesize{" + hostSelector + "}",
            "interval": "",
            "legendFormat": "{{instance}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Request Queue Size",
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
        "datasource": "$datasource",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 58
        },
        "hiddenSeries": false,
        "id": 127,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_network_requestchannel_responsequeuesize{" + hostSelector + ",processor=\"\"}",
            "interval": "",
            "legendFormat": "{{instance}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Response Queue Size",
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
        "collapsed": false,
        "datasource": "$datasource",
        "gridPos": {
          "h": 1,
          "w": 24,
          "x": 0,
          "y": 66
        },
        "id": 86,
        "panels": [],
        "title": "Zookeeper",
        "type": "row"
      },
      {
        "aliasColors": {},
        "bars": false,
        "dashLength": 10,
        "dashes": false,
        "datasource": "$datasource",
        "description": "Latency in millseconds for ZooKeeper requests from broker. ",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 67
        },
        "hiddenSeries": false,
        "id": 88,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_server_zookeeperclientmetrics_zookeeperrequestlatencyms{" + hostSelector + ",quantile=~\"$percentile\"}",
            "hide": false,
            "legendFormat": "{{instance}} - {{quantile}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Zookeeper Request Latency",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
            "format": "ms",
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
        "datasource": "$datasource",
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
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 67
        },
        "hiddenSeries": false,
        "id": 92,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "rate(kafka_server_sessionexpirelistener_zookeepersyncconnectspersec{" + hostSelector + "}[$__rate_interval])",
            "hide": false,
            "instant": false,
            "interval": "",
            "legendFormat": "{{instance}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Zookeeper connections per sec",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
        "datasource": "$datasource",
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
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 75
        },
        "hiddenSeries": false,
        "id": 89,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "rate(kafka_server_sessionexpirelistener_zookeeperexpirespersec{" + hostSelector + "}[$__rate_interval])",
            "hide": false,
            "interval": "",
            "legendFormat": "{{instance}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Zookeeper expired connections per sec",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
        "datasource": "$datasource",
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
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 75
        },
        "hiddenSeries": false,
        "id": 90,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "rate(kafka_server_sessionexpirelistener_zookeeperdisconnectspersec{" + hostSelector + "}[$__rate_interval])",
            "hide": false,
            "interval": "",
            "legendFormat": "{{instance}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Zookeeper disconnect per sec",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
        "datasource": "$datasource",
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
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 83
        },
        "hiddenSeries": false,
        "id": 91,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "rate(kafka_server_sessionexpirelistener_zookeeperauthfailurespersec{" + hostSelector + "}[$__rate_interval])",
            "hide": false,
            "interval": "",
            "legendFormat": "{{instance}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Zookeeper auth failures per sec",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
        "collapsed": false,
        "datasource": "$datasource",
        "gridPos": {
          "h": 1,
          "w": 24,
          "x": 0,
          "y": 91
        },
        "id": 82,
        "panels": [],
        "title": "Isr Shrinks / Expands",
        "type": "row"
      },
      {
        "aliasColors": {},
        "bars": false,
        "dashLength": 10,
        "dashes": false,
        "datasource": "$datasource",
        "description": ": The number of in-sync replicas (ISRs) for a particular partition should remain fairly static, the only exceptions are when you are expanding your broker cluster or removing partitions. In order to maintain high availability, a healthy Kafka cluster requires a minimum number of ISRs for failover. A replica could be removed from the ISR pool for a couple of reasons: it is too far behind the leaders offset (user-configurable by setting the replica.lag.max.messages configuration parameter), or it has not contacted the leader for some time (configurable with the replica.socket.timeout.ms parameter). No matter the reason, an increase in IsrShrinksPerSec without a corresponding increase in IsrExpandsPerSec shortly thereafter is cause for concern and requires user intervention.The Kafka documentation provides a wealth of information on the user-configurable parameters for brokers.",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 92
        },
        "hiddenSeries": false,
        "id": 80,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_server_replicamanager_isrshrinkspersec{" + hostSelector + "}",
            "legendFormat": "{{instance}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "IsrShrinks per Sec",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
            "format": "ops",
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
        "datasource": "$datasource",
        "description": ": The number of in-sync replicas (ISRs) for a particular partition should remain fairly static, the only exceptions are when you are expanding your broker cluster or removing partitions. In order to maintain high availability, a healthy Kafka cluster requires a minimum number of ISRs for failover. A replica could be removed from the ISR pool for a couple of reasons: it is too far behind the leaders offset (user-configurable by setting the replica.lag.max.messages configuration parameter), or it has not contacted the leader for some time (configurable with the replica.socket.timeout.ms parameter). No matter the reason, an increase in IsrShrinksPerSec without a corresponding increase in IsrExpandsPerSec shortly thereafter is cause for concern and requires user intervention.The Kafka documentation provides a wealth of information on the user-configurable parameters for brokers.",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 92
        },
        "hiddenSeries": false,
        "id": 83,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_server_replicamanager_isrexpandspersec{" + hostSelector + "}",
            "hide": false,
            "legendFormat": "{{instance}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "IsrExpands per Sec",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
            "format": "ops",
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
        "collapsed": false,
        "datasource": "$datasource",
        "gridPos": {
          "h": 1,
          "w": 24,
          "x": 0,
          "y": 100
        },
        "id": 53,
        "panels": [],
        "title": "Logs size",
        "type": "row"
      },
      {
        "aliasColors": {},
        "bars": false,
        "dashLength": 10,
        "dashes": false,
        "datasource": "$datasource",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 101
        },
        "hiddenSeries": false,
        "id": 55,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum(kafka_log_log_size{" + hostSelector + ",topic=~\"$topic\"}) by (topic)",
            "interval": "",
            "legendFormat": "{{topic}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Log size per Topic",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
            "format": "decbytes",
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
        "datasource": "$datasource",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 101
        },
        "hiddenSeries": false,
        "id": 56,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum(kafka_log_log_size{" + hostSelector + ",topic=~\"$topic\"}) by (instance)",
            "interval": "",
            "legendFormat": "{{instance}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Log size per Broker",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
            "format": "decbytes",
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
        "collapsed": false,
        "datasource": "$datasource",
        "gridPos": {
          "h": 1,
          "w": 24,
          "x": 0,
          "y": 109
        },
        "id": 58,
        "panels": [],
        "title": "Producer Performance",
        "type": "row"
      },
      {
        "aliasColors": {},
        "bars": false,
        "dashLength": 10,
        "dashes": false,
        "datasource": "$datasource",
        "description": "A high value can imply there aren't enough IO threads or the CPU is a bottleneck, or the request queue isnt large enough. The request queue size should match the number of connections.",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 110
        },
        "hiddenSeries": false,
        "id": 60,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_network_requestmetrics_requestqueuetimems{" + hostSelector + ",quantile=~\"$percentile\",request=\"Produce\"}",
            "hide": false,
            "legendFormat": "{{instance}} - {{quantile}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Producer - RequestQueueTimeMs",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
            "format": "ms",
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
        "datasource": "$datasource",
        "description": "In most cases, a high value can imply slow local storage or the storage is a bottleneck. One should also investigate LogFlushRateAndTimeMs to know how long page flushes are taking, which will also indicate a slow disk. In the case of FetchFollower requests, time spent in LocalTimeMs can be the result of a ZooKeeper write to change the ISR.",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 110
        },
        "hiddenSeries": false,
        "id": 61,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_network_requestmetrics_localtimems{" + hostSelector + ",quantile=~\"$percentile\",request=\"Produce\"}",
            "hide": false,
            "legendFormat": "{{instance}} - {{quantile}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Producer - LocalTimeMs",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
            "format": "ms",
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
        "datasource": "$datasource",
        "description": "A high value can imply a slow network connection. For fetch request, if the remote time is high, it could be that there is not enough data to give in a fetch response. This can happen when the consumer or replica is caught up and there is no new incoming data. If this is the case, remote time will be close to the max wait time, which is normal. Max wait time is configured via replica.fetch.wait.max.ms and fetch.max.wait.ms. ",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 118
        },
        "hiddenSeries": false,
        "id": 62,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_network_requestmetrics_remotetimems{" + hostSelector + ",quantile=~\"$percentile\",request=\"Produce\"}",
            "hide": false,
            "legendFormat": "{{instance}} - {{quantile}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Producer - RemoteTimeMs",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
            "format": "ms",
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
        "datasource": "$datasource",
        "description": "A high value can imply there aren't enough network threads or the network cant dequeue responses quickly enough, causing back pressure in the response queue. ",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 118
        },
        "hiddenSeries": false,
        "id": 63,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_network_requestmetrics_responsequeuetimems{" + hostSelector + ",quantile=~\"$percentile\",request=\"Produce\"}",
            "hide": false,
            "legendFormat": "{{instance}} - {{quantile}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Producer - ResponseQueueTimeMs",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
            "format": "ms",
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
        "datasource": "$datasource",
        "description": "A high value can imply the zero-copy from disk to the network is slow, or the network is the bottleneck because the network cant dequeue responses of the TCP socket as quickly as theyre being created. If the network buffer gets full, Kafka will block. ",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 126
        },
        "hiddenSeries": false,
        "id": 64,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_network_requestmetrics_responsesendtimems{" + hostSelector + ",quantile=~\"$percentile\",request=\"Produce\"}",
            "hide": false,
            "legendFormat": "{{instance}} - {{quantile}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Producer - ResponseSendTimeMs",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
            "format": "ms",
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
        "collapsed": false,
        "datasource": "$datasource",
        "gridPos": {
          "h": 1,
          "w": 24,
          "x": 0,
          "y": 134
        },
        "id": 68,
        "panels": [],
        "title": "Consumer Performance",
        "type": "row"
      },
      {
        "aliasColors": {},
        "bars": false,
        "dashLength": 10,
        "dashes": false,
        "datasource": "$datasource",
        "description": "A high value can imply there aren't enough IO threads or the CPU is a bottleneck, or the request queue isnt large enough. The request queue size should match the number of connections.",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 135
        },
        "hiddenSeries": false,
        "id": 69,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_network_requestmetrics_requestqueuetimems{" + hostSelector + ",quantile=~\"$percentile\",request=\"Fetch\"}",
            "hide": false,
            "legendFormat": "{{instance}} - {{quantile}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Consumer - RequestQueueTimeMs",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
            "format": "ms",
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
        "datasource": "$datasource",
        "description": "In most cases, a high value can imply slow local storage or the storage is a bottleneck. One should also investigate LogFlushRateAndTimeMs to know how long page flushes are taking, which will also indicate a slow disk. In the case of FetchFollower requests, time spent in LocalTimeMs can be the result of a ZooKeeper write to change the ISR.",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 135
        },
        "hiddenSeries": false,
        "id": 70,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_network_requestmetrics_localtimems{" + hostSelector + ",quantile=~\"$percentile\",request=\"Fetch\"}",
            "hide": false,
            "legendFormat": "{{instance}} - {{quantile}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Consumer - LocalTimeMs",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
            "format": "ms",
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
        "datasource": "$datasource",
        "description": "A high value can imply a slow network connection. For fetch request, if the remote time is high, it could be that there is not enough data to give in a fetch response. This can happen when the consumer or replica is caught up and there is no new incoming data. If this is the case, remote time will be close to the max wait time, which is normal. Max wait time is configured via replica.fetch.wait.max.ms and fetch.max.wait.ms. ",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 143
        },
        "hiddenSeries": false,
        "id": 71,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_network_requestmetrics_remotetimems{" + hostSelector + ",quantile=~\"$percentile\",request=\"Fetch\"}",
            "hide": false,
            "legendFormat": "{{instance}} - {{quantile}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Consumer - RemoteTimeMs",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
            "format": "ms",
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
        "datasource": "$datasource",
        "description": "A high value can imply there aren't enough network threads or the network cant dequeue responses quickly enough, causing back pressure in the response queue. ",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 143
        },
        "hiddenSeries": false,
        "id": 72,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_network_requestmetrics_responsequeuetimems{" + hostSelector + ",quantile=~\"$percentile\",request=\"Fetch\"}",
            "hide": false,
            "legendFormat": "{{instance}} - {{quantile}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Consumer - ResponseQueueTimeMs",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
            "format": "ms",
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
        "datasource": "$datasource",
        "description": "A high value can imply the zero-copy from disk to the network is slow, or the network is the bottleneck because the network cant dequeue responses of the TCP socket as quickly as theyre being created. If the network buffer gets full, Kafka will block. ",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 151
        },
        "hiddenSeries": false,
        "id": 73,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_network_requestmetrics_responsesendtimems{" + hostSelector + ",quantile=~\"$percentile\",request=\"Fetch\"}",
            "hide": false,
            "legendFormat": "{{instance}} - {{quantile}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Consumer - ResponseSendTimeMs",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
            "format": "ms",
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
        "collapsed": false,
        "datasource": "$datasource",
        "gridPos": {
          "h": 1,
          "w": 24,
          "x": 0,
          "y": 159
        },
        "id": 66,
        "panels": [],
        "title": "Fetch Follower Performance",
        "type": "row"
      },
      {
        "aliasColors": {},
        "bars": false,
        "dashLength": 10,
        "dashes": false,
        "datasource": "$datasource",
        "description": "A high value can imply there aren't enough IO threads or the CPU is a bottleneck, or the request queue isnt large enough. The request queue size should match the number of connections.",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 160
        },
        "hiddenSeries": false,
        "id": 74,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_network_requestmetrics_requestqueuetimems{" + hostSelector + ",quantile=~\"$percentile\",request=\"FetchFollower\"}",
            "hide": false,
            "legendFormat": "{{instance}} - {{quantile}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "FetchFollower - RequestQueueTimeMs",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
            "format": "ms",
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
        "datasource": "$datasource",
        "description": "In most cases, a high value can imply slow local storage or the storage is a bottleneck. One should also investigate LogFlushRateAndTimeMs to know how long page flushes are taking, which will also indicate a slow disk. In the case of FetchFollower requests, time spent in LocalTimeMs can be the result of a ZooKeeper write to change the ISR.",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 160
        },
        "hiddenSeries": false,
        "id": 75,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_network_requestmetrics_localtimems{" + hostSelector + ",quantile=~\"$percentile\",request=\"FetchFollower\"}",
            "hide": false,
            "legendFormat": "{{instance}} - {{quantile}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "FetchFollower - LocalTimeMs",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
            "format": "ms",
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
        "datasource": "$datasource",
        "description": "A high value can imply a slow network connection. For fetch request, if the remote time is high, it could be that there is not enough data to give in a fetch response. This can happen when the consumer or replica is caught up and there is no new incoming data. If this is the case, remote time will be close to the max wait time, which is normal. Max wait time is configured via replica.fetch.wait.max.ms and fetch.max.wait.ms. ",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 168
        },
        "hiddenSeries": false,
        "id": 76,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_network_requestmetrics_remotetimems{" + hostSelector + ",quantile=~\"$percentile\",request=\"FetchFollower\"}",
            "hide": false,
            "legendFormat": "{{instance}} - {{quantile}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "FetchFollower - RemoteTimeMs",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
            "format": "ms",
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
        "datasource": "$datasource",
        "description": "A high value can imply there aren't enough network threads or the network cant dequeue responses quickly enough, causing back pressure in the response queue. ",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 168
        },
        "hiddenSeries": false,
        "id": 77,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_network_requestmetrics_responsequeuetimems{" + hostSelector + ",quantile=~\"$percentile\",request=\"FetchFollower\"}",
            "hide": false,
            "legendFormat": "{{instance}} - {{quantile}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "FetchFollower - ResponseQueueTimeMs",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
            "format": "ms",
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
        "datasource": "$datasource",
        "description": "A high value can imply the zero-copy from disk to the network is slow, or the network is the bottleneck because the network cant dequeue responses of the TCP socket as quickly as theyre being created. If the network buffer gets full, Kafka will block. ",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 176
        },
        "hiddenSeries": false,
        "id": 78,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_network_requestmetrics_responsesendtimems{" + hostSelector + ",quantile=~\"$percentile\",request=\"FetchFollower\"}",
            "hide": false,
            "legendFormat": "{{instance}} - {{quantile}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "FetchFollower - ResponseSendTimeMs",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
            "format": "ms",
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
        "collapsed": false,
        "datasource": "$datasource",
        "gridPos": {
          "h": 1,
          "w": 24,
          "x": 0,
          "y": 184
        },
        "id": 97,
        "panels": [],
        "title": "Group Coordinator",
        "type": "row"
      },
      {
        "aliasColors": {},
        "bars": false,
        "dashLength": 10,
        "dashes": false,
        "datasource": "$datasource",
        "description": "Number of consumer groups per group coordinator",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 185
        },
        "hiddenSeries": false,
        "id": 99,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_coordinator_group_groupmetadatamanager_numgroups{" + hostSelector + "}",
            "instant": false,
            "interval": "",
            "legendFormat": "{{instance}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Consumer groups number per coordinator",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
        "datasource": "$datasource",
        "description": "Number of consumer group per state",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 185
        },
        "hiddenSeries": false,
        "id": 100,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum(kafka_coordinator_group_groupmetadatamanager_numgroupsstable{" + hostSelector + "})",
            "instant": false,
            "interval": "",
            "legendFormat": "stable",
            "refId": "A"
          },
          {
            "expr": "sum(kafka_coordinator_group_groupmetadatamanager_numgroupspreparingrebalance{" + hostSelector + "})",
            "interval": "",
            "legendFormat": "preparing-rebalance",
            "refId": "B"
          },
          {
            "expr": "sum(kafka_coordinator_group_groupmetadatamanager_numgroupsdead{" + hostSelector + "})",
            "interval": "",
            "legendFormat": "dead",
            "refId": "C"
          },
          {
            "expr": "sum(kafka_coordinator_group_groupmetadatamanager_numgroupscompletingrebalance{" + hostSelector + "})",
            "interval": "",
            "legendFormat": "completing-rebalance",
            "refId": "D"
          },
          {
            "expr": "sum(kafka_coordinator_group_groupmetadatamanager_numgroupsempty{" + hostSelector + "})",
            "interval": "",
            "legendFormat": "empty",
            "refId": "E"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Nb consumer groups per state",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
        "collapsed": false,
        "datasource": "$datasource",
        "gridPos": {
          "h": 1,
          "w": 24,
          "x": 0,
          "y": 193
        },
        "id": 102,
        "panels": [],
        "title": "Connections",
        "type": "row"
      },
      {
        "aliasColors": {},
        "bars": false,
        "dashLength": 10,
        "dashes": false,
        "datasource": "$datasource",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 194
        },
        "hiddenSeries": false,
        "id": 104,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum(kafka_server_socketservermetrics_connection_count{" + hostSelector + "}) by (listener)",
            "interval": "",
            "legendFormat": "{{listener}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Connections count per listener",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
        "datasource": "$datasource",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 194
        },
        "hiddenSeries": false,
        "id": 105,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum(kafka_server_socketservermetrics_connection_count{" + hostSelector + "}) by (instance)",
            "interval": "",
            "legendFormat": "{{instance}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Connections count per broker",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
        "datasource": "$datasource",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 202
        },
        "hiddenSeries": false,
        "id": 106,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum(kafka_server_socketservermetrics_connection_creation_rate{" + hostSelector + "}) by (listener)",
            "interval": "",
            "legendFormat": "{{listener}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Connections creation rate per listener",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
        "datasource": "$datasource",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 202
        },
        "hiddenSeries": false,
        "id": 107,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum(kafka_server_socketservermetrics_connection_creation_rate{" + hostSelector + "}) by (instance)",
            "interval": "",
            "legendFormat": "{{instance}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Connections creation rate per instance",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
        "datasource": "$datasource",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 210
        },
        "hiddenSeries": false,
        "id": 108,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum(kafka_server_socketservermetrics_connection_close_rate{" + hostSelector + "}) by (listener)",
            "interval": "",
            "legendFormat": "{{listener}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Connections close rate per listener",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
        "datasource": "$datasource",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 210
        },
        "hiddenSeries": false,
        "id": 110,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum(kafka_server_socketservermetrics_connection_close_rate{" + hostSelector + "}) by (instance)",
            "interval": "",
            "legendFormat": "{{instance}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Connections close rate per instance",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
        "datasource": "$datasource",
        "description": "Tracks the amount of time Acceptor is blocked from accepting connections. See KIP-402 for more details.",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 218
        },
        "hiddenSeries": false,
        "id": 124,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_network_acceptor_acceptorblockedpercent{" + hostSelector + "}",
            "interval": "",
            "legendFormat": "{{instance}} - {{listener}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Acceptor Blocked Percentage",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
        "datasource": "$datasource",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 218
        },
        "hiddenSeries": false,
        "id": 113,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum(kafka_server_socketservermetrics_connections{" + hostSelector + "}) by (client_software_name, client_software_version)",
            "interval": "",
            "legendFormat": "{{client_software_name}} {{client_software_version}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Connections per client version",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
        "collapsed": false,
        "datasource": "$datasource",
        "gridPos": {
          "h": 1,
          "w": 24,
          "x": 0,
          "y": 226
        },
        "id": 31,
        "panels": [],
        "title": "Request rate",
        "type": "row"
      },
      {
        "cacheTimeout": null,
        "datasource": "$datasource",
        "description": "Total request rate.",
        "fieldConfig": {
          "defaults": {
            "mappings": [
              {
                "id": 0,
                "op": "=",
                "text": "N/A",
                "type": 1,
                "value": "null"
              }
            ],
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {
                  "color": "green",
                  "value": null
                }
              ]
            },
            "unit": "none"
          },
          "overrides": []
        },
        "gridPos": {
          "h": 4,
          "w": 4,
          "x": 0,
          "y": 227
        },
        "id": 37,
        "interval": null,
        "links": [],
        "maxDataPoints": 100,
        "options": {
          "colorMode": "value",
          "fieldOptions": {
            "calcs": [
              "lastNotNull"
            ]
          },
          "graphMode": "area",
          "justifyMode": "auto",
          "orientation": "horizontal",
          "reduceOptions": {
            "calcs": [
              "last"
            ],
            "fields": "",
            "values": false
          },
          "text": {},
          "textMode": "auto"
        },
        "pluginVersion": "7.5.6",
        "targets": [
          {
            "expr": "sum(rate(kafka_network_requestmetrics_requestspersec{" + hostSelector + "}[$__rate_interval]))",
            "interval": "",
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "timeFrom": null,
        "timeShift": null,
        "title": "Total Request Per Sec",
        "type": "stat"
      },
      {
        "cacheTimeout": null,
        "datasource": "$datasource",
        "description": "Produce request rate.",
        "fieldConfig": {
          "defaults": {
            "mappings": [
              {
                "id": 0,
                "op": "=",
                "text": "N/A",
                "type": 1,
                "value": "null"
              }
            ],
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {
                  "color": "green",
                  "value": null
                }
              ]
            },
            "unit": "none"
          },
          "overrides": []
        },
        "gridPos": {
          "h": 4,
          "w": 4,
          "x": 4,
          "y": 227
        },
        "id": 112,
        "interval": null,
        "links": [],
        "maxDataPoints": 100,
        "options": {
          "colorMode": "value",
          "fieldOptions": {
            "calcs": [
              "lastNotNull"
            ]
          },
          "graphMode": "area",
          "justifyMode": "auto",
          "orientation": "horizontal",
          "reduceOptions": {
            "calcs": [
              "last"
            ],
            "fields": "",
            "values": false
          },
          "text": {},
          "textMode": "auto"
        },
        "pluginVersion": "7.5.6",
        "targets": [
          {
            "expr": "sum(rate(kafka_network_requestmetrics_requestspersec{" + hostSelector + ",request=\"Produce\"}[$__rate_interval]))",
            "interval": "",
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "timeFrom": null,
        "timeShift": null,
        "title": "Produce Request Per Sec",
        "type": "stat"
      },
      {
        "cacheTimeout": null,
        "datasource": "$datasource",
        "description": "Fetch request rate.",
        "fieldConfig": {
          "defaults": {
            "mappings": [
              {
                "id": 0,
                "op": "=",
                "text": "N/A",
                "type": 1,
                "value": "null"
              }
            ],
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {
                  "color": "green",
                  "value": null
                }
              ]
            },
            "unit": "none"
          },
          "overrides": []
        },
        "gridPos": {
          "h": 4,
          "w": 4,
          "x": 8,
          "y": 227
        },
        "id": 111,
        "interval": null,
        "links": [],
        "maxDataPoints": 100,
        "options": {
          "colorMode": "value",
          "fieldOptions": {
            "calcs": [
              "lastNotNull"
            ]
          },
          "graphMode": "area",
          "justifyMode": "auto",
          "orientation": "horizontal",
          "reduceOptions": {
            "calcs": [
              "last"
            ],
            "fields": "",
            "values": false
          },
          "text": {},
          "textMode": "auto"
        },
        "pluginVersion": "7.5.6",
        "targets": [
          {
            "expr": "sum(rate(kafka_network_requestmetrics_requestspersec{" + hostSelector + ",request=\"FetchConsumer\"}[$__rate_interval]))",
            "interval": "",
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "timeFrom": null,
        "timeShift": null,
        "title": "Fetch Request Per Sec",
        "type": "stat"
      },
      {
        "cacheTimeout": null,
        "datasource": "$datasource",
        "description": "Offset Commit request rate.",
        "fieldConfig": {
          "defaults": {
            "mappings": [
              {
                "id": 0,
                "op": "=",
                "text": "N/A",
                "type": 1,
                "value": "null"
              }
            ],
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {
                  "color": "green",
                  "value": null
                }
              ]
            },
            "unit": "none"
          },
          "overrides": []
        },
        "gridPos": {
          "h": 4,
          "w": 4,
          "x": 12,
          "y": 227
        },
        "id": 38,
        "interval": null,
        "links": [],
        "maxDataPoints": 100,
        "options": {
          "colorMode": "value",
          "fieldOptions": {
            "calcs": [
              "lastNotNull"
            ]
          },
          "graphMode": "area",
          "justifyMode": "auto",
          "orientation": "horizontal",
          "reduceOptions": {
            "calcs": [
              "last"
            ],
            "fields": "",
            "values": false
          },
          "text": {},
          "textMode": "auto"
        },
        "pluginVersion": "7.5.6",
        "targets": [
          {
            "expr": "sum(rate(kafka_network_requestmetrics_requestspersec{" + hostSelector + ",request=\"OffsetCommit\"}[$__rate_interval]))",
            "interval": "",
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "timeFrom": null,
        "timeShift": null,
        "title": "Offset Commit Request Per Sec",
        "type": "stat"
      },
      {
        "cacheTimeout": null,
        "datasource": "$datasource",
        "description": "Metadata request rate.",
        "fieldConfig": {
          "defaults": {
            "mappings": [
              {
                "id": 0,
                "op": "=",
                "text": "N/A",
                "type": 1,
                "value": "null"
              }
            ],
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {
                  "color": "green",
                  "value": null
                }
              ]
            },
            "unit": "none"
          },
          "overrides": []
        },
        "gridPos": {
          "h": 4,
          "w": 4,
          "x": 16,
          "y": 227
        },
        "id": 36,
        "interval": null,
        "links": [],
        "maxDataPoints": 100,
        "options": {
          "colorMode": "value",
          "fieldOptions": {
            "calcs": [
              "lastNotNull"
            ]
          },
          "graphMode": "area",
          "justifyMode": "auto",
          "orientation": "horizontal",
          "reduceOptions": {
            "calcs": [
              "last"
            ],
            "fields": "",
            "values": false
          },
          "text": {},
          "textMode": "auto"
        },
        "pluginVersion": "7.5.6",
        "targets": [
          {
            "expr": "sum(rate(kafka_network_requestmetrics_requestspersec{" + hostSelector + ",request=\"Metadata\"}[$__rate_interval]))",
            "interval": "",
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "timeFrom": null,
        "timeShift": null,
        "title": "Metadata Request Per Sec",
        "type": "stat"
      },
      {
        "aliasColors": {},
        "bars": false,
        "dashLength": 10,
        "dashes": false,
        "datasource": "$datasource",
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
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 231
        },
        "hiddenSeries": false,
        "id": 94,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum(rate(kafka_server_brokertopicmetrics_totalproducerequestspersec{" + hostSelector + ",topic=~\"$topic\"}[$__rate_interval])) by (topic)",
            "interval": "",
            "legendFormat": "{{topic}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Produce request per sec per topic",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
        "datasource": "$datasource",
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
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 231
        },
        "hiddenSeries": false,
        "id": 95,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum(rate(kafka_server_brokertopicmetrics_totalfetchrequestspersec{" + hostSelector + ",topic=~\"$topic\"}[$__rate_interval])) by (topic)",
            "interval": "",
            "legendFormat": "{{topic}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Fetch request per sec per topic",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
        "collapsed": false,
        "datasource": "$datasource",
        "gridPos": {
          "h": 1,
          "w": 24,
          "x": 0,
          "y": 239
        },
        "id": 46,
        "panels": [],
        "title": "Message Conversion",
        "type": "row"
      },
      {
        "aliasColors": {},
        "bars": false,
        "dashLength": 10,
        "dashes": false,
        "datasource": "$datasource",
        "description": "The number of messages produced converted to match the log.message.format.version.",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 240
        },
        "hiddenSeries": false,
        "id": 48,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum(rate(kafka_server_brokertopicmetrics_producemessageconversionspersec{" + hostSelector + "}[$__rate_interval]))",
            "hide": false,
            "interval": "",
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Number of procuded message conversion",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
            "format": "iops",
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
        "description": "The number of messages consumed converted at consumer to match the log.message.format.version.",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 240
        },
        "hiddenSeries": false,
        "id": 51,
        "legend": {
          "avg": false,
          "current": false,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 1,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "sum(rate(kafka_server_brokertopicmetrics_fetchmessageconversionspersec{" + hostSelector + "}[$__rate_interval]))",
            "hide": false,
            "interval": "",
            "legendFormat": "{{topic}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Number of consumed message conversion",
        "tooltip": {
          "shared": true,
          "sort": 2,
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
            "format": "iops",
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
        "datasource": "$datasource",
        "description": "Number of connection per client version",
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
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 248
        },
        "id": 115,
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
        "targets": [
          {
            "expr": "sum(kafka_server_socketservermetrics_connections{" + hostSelector + "}) by (client_software_name, client_software_version) ",
            "interval": "",
            "legendFormat": "{{client_software_name}} - {{client_software_version}}",
            "refId": "A"
          }
        ],
        "timeFrom": null,
        "timeShift": null,
        "title": "Client version repartition",
        "type": "piechart"
      }
    ],
    "refresh": "30s",
    "schemaVersion": 27,
    "style": "dark",
    "tags": [
      "kafka-integration"
    ],
    "templating": {
      "list": [
        {
          "current": {},
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
          "definition": "label_values(kafka_server_kafkaserver_brokerstate{" + filterSelector + "}, job)",
          "description": null,
          "error": null,
          "hide": 0,
          "includeAll": true,
          "label": "Job",
          "multi": true,
          "name": "job",
          "options": [],
          "query": {
            "query": "label_values(kafka_server_kafkaserver_brokerstate{" + filterSelector + "}, job)",
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
          "definition": "label_values(kafka_server_kafkaserver_brokerstate{" + jobSelector + "}, kafka_cluster)",
          "description": null,
          "error": null,
          "hide": 0,
          "includeAll": true,
          "label": "Kafka Cluster",
          "multi": true,
          "name": "kafka_cluster",
          "options": [],
          "query": {
            "query": "label_values(kafka_server_kafkaserver_brokerstate{" + jobSelector + "}, kafka_cluster)",
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
          "definition": "label_values(kafka_server_kafkaserver_brokerstate{" + jobSelector + ", " + kafkaClusterSelector + "}, instance)",
          "description": null,
          "error": null,
          "hide": 0,
          "includeAll": true,
          "label": "Instance",
          "multi": true,
          "name": "instance",
          "options": [],
          "query": {
            "query": "label_values(kafka_server_kafkaserver_brokerstate{" + jobSelector + ", " + kafkaClusterSelector + "}, instance)",
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
          "current": {
            "selected": false,
            "text": [
              "0.99"
            ],
            "value": [
              "0.99"
            ]
          },
          "datasource": "${datasource}",
          "definition": "label_values(kafka_network_requestmetrics_requestqueuetimems{" + hostSelector + "}, quantile)",
          "description": null,
          "error": null,
          "hide": 0,
          "includeAll": true,
          "label": "Percentile",
          "multi": true,
          "name": "percentile",
          "options": [],
          "query": {
            "query": "label_values(kafka_network_requestmetrics_requestqueuetimems{" + hostSelector + "}, quantile)",
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
          "definition": "label_values(kafka_log_log_size{" + hostSelector + "},topic)",
          "description": null,
          "error": null,
          "hide": 0,
          "includeAll": true,
          "label": "Topic",
          "multi": true,
          "name": "topic",
          "options": [],
          "query": {
            "query": "label_values(kafka_log_log_size{" + hostSelector + "},topic)",
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
      "from": "now-30m",
      "to": "now"
    },
    "timepicker": {
      "refresh_intervals": [
        "10s",
        "30s",
        "1m",
        "5m",
        "15m",
        "30m",
        "1h",
        "2h",
        "1d"
      ],
      "time_options": [
        "5m",
        "15m",
        "1h",
        "6h",
        "12h",
        "24h",
        "2d",
        "7d",
        "30d"
      ]
    },
    "timezone": "browser",
    "title": "Kafka Overview",
    "uid": "qu-QZdfZz",
    "version": 1
  };

{
  grafanaDashboards+::
  {
    'kafka-overview.json': dashboard
  }
}