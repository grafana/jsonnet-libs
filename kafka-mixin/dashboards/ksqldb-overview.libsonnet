local config = (import '../config.libsonnet');
local filterSelector = "job=~\"integrations/kafka-ksqldb|integrations/kafka\"";
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
    "id": 7,
    "iteration": 1623181722775,
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
        "id": 29,
        "panels": [],
        "title": "Overview",
        "type": "row"
      },
      {
        "cacheTimeout": null,
        "datasource": "${datasource}",
        "description": "Average number of active queries per server.",
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
          "y": 1
        },
        "id": 18,
        "interval": null,
        "links": [],
        "maxDataPoints": 100,
        "options": {
          "colorMode": "value",
          "graphMode": "none",
          "justifyMode": "auto",
          "orientation": "horizontal",
          "reduceOptions": {
            "calcs": [
              "lastNotNull"
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
            "expr": "avg(ksql_ksql_engine_query_stats_num_active_queries{ksql_cluster=\"$clusterid\", " + hostSelector + "})",
            "instant": true,
            "interval": "",
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "timeFrom": null,
        "timeShift": null,
        "title": "Active Queries",
        "type": "stat"
      },
      {
        "cacheTimeout": null,
        "datasource": "${datasource}",
        "description": "Num of created queries",
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
                  "value": 500
                },
                {
                  "color": "#d44a3a",
                  "value": 800
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
        "id": 20,
        "interval": null,
        "links": [],
        "maxDataPoints": 100,
        "options": {
          "colorMode": "value",
          "graphMode": "none",
          "justifyMode": "auto",
          "orientation": "horizontal",
          "reduceOptions": {
            "calcs": [
              "lastNotNull"
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
            "expr": "avg(ksql_ksql_engine_query_stats_running_queries{ksql_cluster=\"$clusterid\", " + hostSelector + "})",
            "interval": "",
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "timeFrom": null,
        "timeShift": null,
        "title": "Running Queries",
        "type": "stat"
      },
      {
        "cacheTimeout": null,
        "datasource": "${datasource}",
        "description": "Num of persisted queries",
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
          "y": 1
        },
        "id": 2,
        "interval": null,
        "links": [],
        "maxDataPoints": 100,
        "options": {
          "colorMode": "value",
          "graphMode": "none",
          "justifyMode": "auto",
          "orientation": "horizontal",
          "reduceOptions": {
            "calcs": [
              "lastNotNull"
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
            "expr": "avg(ksql_ksql_engine_query_stats_num_persistent_queries{ksql_cluster=\"$clusterid\", " + hostSelector + "})",
            "interval": "",
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "timeFrom": null,
        "timeShift": null,
        "title": "Total Persisted Queries",
        "type": "stat"
      },
      {
        "cacheTimeout": null,
        "datasource": "${datasource}",
        "description": "Num of rebalancing queries",
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
                  "color": "#d44a3a",
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
          "x": 12,
          "y": 1
        },
        "id": 16,
        "interval": null,
        "links": [],
        "maxDataPoints": 100,
        "options": {
          "colorMode": "value",
          "graphMode": "none",
          "justifyMode": "auto",
          "orientation": "horizontal",
          "reduceOptions": {
            "calcs": [
              "lastNotNull"
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
            "expr": "sum(ksql_ksql_engine_query_stats_rebalancing_queries{ksql_cluster=\"$clusterid\", " + hostSelector + "})",
            "interval": "",
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "timeFrom": null,
        "timeShift": null,
        "title": "Rebalancing Queries",
        "type": "stat"
      },
      {
        "cacheTimeout": null,
        "datasource": "${datasource}",
        "description": "Number of error query",
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
                  "color": "#d44a3a",
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
          "x": 16,
          "y": 1
        },
        "id": 4,
        "interval": null,
        "links": [],
        "maxDataPoints": 100,
        "options": {
          "colorMode": "value",
          "graphMode": "none",
          "justifyMode": "auto",
          "orientation": "horizontal",
          "reduceOptions": {
            "calcs": [
              "lastNotNull"
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
            "expr": "avg(ksql_ksql_engine_query_stats_error_queries{ksql_cluster=\"$clusterid\", " + hostSelector + "})",
            "interval": "",
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "timeFrom": null,
        "timeShift": null,
        "title": "Queries in Error State",
        "type": "stat"
      },
      {
        "cacheTimeout": null,
        "datasource": "${datasource}",
        "description": "Num of idle queries",
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
                  "color": "#d44a3a",
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
          "x": 20,
          "y": 1
        },
        "id": 19,
        "interval": null,
        "links": [],
        "maxDataPoints": 100,
        "options": {
          "colorMode": "value",
          "graphMode": "none",
          "justifyMode": "auto",
          "orientation": "horizontal",
          "reduceOptions": {
            "calcs": [
              "lastNotNull"
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
            "expr": "sum(ksql_ksql_engine_query_stats_num_idle_queries{ksql_cluster=\"$clusterid\", " + hostSelector + "})",
            "interval": "",
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "timeFrom": null,
        "timeShift": null,
        "title": "Idle Queries",
        "type": "stat"
      },
      {
        "datasource": "${datasource}",
        "fieldConfig": {
          "defaults": {
            "custom": {
              "align": null,
              "displayMode": "auto",
              "filterable": false
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
          "overrides": [
            {
              "matcher": {
                "id": "byName",
                "options": "ksql_query"
              },
              "properties": [
                {
                  "id": "custom.width",
                  "value": 426
                }
              ]
            },
            {
              "matcher": {
                "id": "byName",
                "options": "instance"
              },
              "properties": [
                {
                  "id": "custom.width",
                  "value": 381
                }
              ]
            }
          ]
        },
        "gridPos": {
          "h": 9,
          "w": 16,
          "x": 0,
          "y": 5
        },
        "id": 23,
        "options": {
          "showHeader": true,
          "sortBy": []
        },
        "pluginVersion": "7.5.6",
        "targets": [
          {
            "expr": "ksql_ksql_metrics_ksql_queries_query_status{ksql_cluster=\"$clusterid\", " + hostSelector + "}",
            "format": "table",
            "instant": true,
            "interval": "",
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "timeFrom": null,
        "timeShift": null,
        "title": "Queries Status",
        "transformations": [
          {
            "id": "organize",
            "options": {
              "excludeByName": {
                "Time": true,
                "Value": true,
                "__name__": true,
                "env": true,
                "job": true,
                "ksql_cluster": true
              },
              "indexByName": {},
              "renameByName": {
                "Time": "",
                "__name__": "",
                "instance": "",
                "ksql_cluster": "",
                "ksql_query": ""
              }
            }
          }
        ],
        "type": "table"
      },
      {
        "cacheTimeout": null,
        "datasource": "${datasource}",
        "description": "Num of not running queries",
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
                  "color": "#d44a3a",
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
          "x": 16,
          "y": 5
        },
        "id": 5,
        "interval": null,
        "links": [],
        "maxDataPoints": 100,
        "options": {
          "colorMode": "value",
          "graphMode": "none",
          "justifyMode": "auto",
          "orientation": "horizontal",
          "reduceOptions": {
            "calcs": [
              "lastNotNull"
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
            "expr": "sum(ksql_ksql_engine_query_stats_not_running_queries{ksql_cluster=\"$clusterid\", " + hostSelector + "})",
            "interval": "",
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "timeFrom": null,
        "timeShift": null,
        "title": "Stopped Queries",
        "type": "stat"
      },
      {
        "cacheTimeout": null,
        "datasource": "${datasource}",
        "description": "Num of running queries",
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
                  "color": "#d44a3a",
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
          "x": 20,
          "y": 5
        },
        "id": 15,
        "interval": null,
        "links": [],
        "maxDataPoints": 100,
        "options": {
          "colorMode": "value",
          "graphMode": "none",
          "justifyMode": "auto",
          "orientation": "horizontal",
          "reduceOptions": {
            "calcs": [
              "lastNotNull"
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
            "expr": "sum(ksql_ksql_engine_query_stats_pending_shutdown_queries{ksql_cluster=\"$clusterid\", " + hostSelector + "})",
            "interval": "",
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "timeFrom": null,
        "timeShift": null,
        "title": "Currently Shutting Down Queries",
        "type": "stat"
      },
      {
        "aliasColors": {},
        "bars": false,
        "cacheTimeout": null,
        "dashLength": 10,
        "dashes": false,
        "datasource": "${datasource}",
        "decimals": 0,
        "description": "Cluster liveness",
        "fieldConfig": {
          "defaults": {
            "links": []
          },
          "overrides": []
        },
        "fill": 1,
        "fillGradient": 0,
        "gridPos": {
          "h": 5,
          "w": 8,
          "x": 16,
          "y": 9
        },
        "hiddenSeries": false,
        "id": 17,
        "interval": null,
        "legend": {
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
        "links": [],
        "maxDataPoints": 100,
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
            "expr": "ksql_ksql_engine_query_stats_liveness_indicator{ksql_cluster=\"$clusterid\", " + hostSelector + "}",
            "interval": "",
            "legendFormat": "{{instance}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Cluster liveness",
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
            "max": "1",
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
        "description": "Message consumed/sec",
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
          "y": 14
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
            "expr": "ksql_ksql_engine_query_stats_messages_consumed_per_sec{ksql_cluster=\"$clusterid\", " + hostSelector + "}",
            "interval": "",
            "legendFormat": "{{instance}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Message consumed/sec",
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
        "description": "Message produced/sec",
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
          "y": 14
        },
        "hiddenSeries": false,
        "id": 7,
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
            "expr": "irate(ksql_ksql_engine_query_stats_messages_produced_per_sec{ksql_cluster=\"$clusterid\", " + hostSelector + "}[$__rate_interval])",
            "interval": "",
            "legendFormat": "{{instance}}",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Message produced/sec",
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
          "y": 22
        },
        "id": 33,
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
        "decimals": 1,
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
          "h": 9,
          "w": 8,
          "x": 0,
          "y": 23
        },
        "hiddenSeries": false,
        "id": 12,
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
            "expr": "irate(process_cpu_seconds_total{" + hostSelector + "}[$__rate_interval])",
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
            "decimals": null,
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
          "h": 9,
          "w": 8,
          "x": 8,
          "y": 23
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
            "expr": "sum without(area)(jvm_memory_bytes_used{ " + hostSelector + "})",
            "interval": "",
            "legendFormat": "Used:{{instance}}",
            "refId": "A"
          },
          {
            "expr": "jvm_memory_bytes_max{area=\"heap\", " + hostSelector + "}",
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
        "datasource": "${datasource}",
        "decimals": 2,
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
          "h": 9,
          "w": 8,
          "x": 16,
          "y": 23
        },
        "hiddenSeries": false,
        "id": 14,
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
            "decimals": 4,
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
        "id": 31,
        "panels": [],
        "title": "Queries Performance",
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
        "fill": 0,
        "fillGradient": 0,
        "gridPos": {
          "h": 11,
          "w": 6,
          "x": 0,
          "y": 33
        },
        "hiddenSeries": false,
        "id": 26,
        "legend": {
          "alignAsTable": true,
          "avg": true,
          "current": true,
          "hideEmpty": true,
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
            "expr": "kafka_streams_stream_thread_metrics_poll_latency_avg{thread_id=~\".+$clusterid.+\", " + hostSelector + "}",
            "format": "time_series",
            "hide": false,
            "instant": false,
            "interval": "",
            "legendFormat": "{{thread_id}}_avg",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Poll Latency (Avg)",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "transformations": [],
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
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          },
          {
            "format": "short",
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": false
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
        "fill": 0,
        "fillGradient": 0,
        "gridPos": {
          "h": 11,
          "w": 6,
          "x": 6,
          "y": 33
        },
        "hiddenSeries": false,
        "id": 35,
        "legend": {
          "avg": false,
          "current": false,
          "hideEmpty": true,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 2,
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
            "expr": "kafka_streams_stream_thread_metrics_poll_latency_max{thread_id=~\".+$clusterid.+\", " + hostSelector + "}",
            "interval": "",
            "legendFormat": "{{thread_id}}_max",
            "refId": "B"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Poll Latency (Max)",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "transformations": [],
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
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          },
          {
            "format": "short",
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": false
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
        "fill": 0,
        "fillGradient": 0,
        "gridPos": {
          "h": 11,
          "w": 6,
          "x": 12,
          "y": 33
        },
        "hiddenSeries": false,
        "id": 25,
        "legend": {
          "avg": false,
          "current": false,
          "hideEmpty": true,
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
            "expr": "kafka_streams_stream_thread_metrics_process_latency_avg{thread_id=~\".+$clusterid.+\", " + hostSelector + "}",
            "format": "time_series",
            "instant": false,
            "interval": "",
            "legendFormat": "{{thread_id}}_avg",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Process Latency (Avg)",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "transformations": [],
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
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          },
          {
            "format": "short",
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": false
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
        "fill": 0,
        "fillGradient": 0,
        "gridPos": {
          "h": 11,
          "w": 6,
          "x": 18,
          "y": 33
        },
        "hiddenSeries": false,
        "id": 34,
        "legend": {
          "avg": false,
          "current": false,
          "hideEmpty": true,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 2,
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
            "expr": "kafka_streams_stream_thread_metrics_process_latency_max{thread_id=~\".+$clusterid.+\", " + hostSelector + "}",
            "interval": "",
            "legendFormat": "{{thread_id}}_max",
            "refId": "B"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Process Latency Max",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "transformations": [],
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
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          },
          {
            "format": "short",
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": false
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
        "fill": 0,
        "fillGradient": 0,
        "gridPos": {
          "h": 11,
          "w": 6,
          "x": 0,
          "y": 44
        },
        "hiddenSeries": false,
        "id": 13,
        "legend": {
          "avg": false,
          "current": false,
          "hideEmpty": true,
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
            "expr": "kafka_streams_stream_thread_metrics_commit_latency_avg{thread_id=~\".+$clusterid.+\", " + hostSelector + "}",
            "format": "time_series",
            "instant": false,
            "interval": "",
            "legendFormat": "{{thread_id}}_avg",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Commit Latency (Avg)",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "transformations": [],
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
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          },
          {
            "format": "short",
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": false
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
        "fill": 0,
        "fillGradient": 0,
        "gridPos": {
          "h": 11,
          "w": 6,
          "x": 6,
          "y": 44
        },
        "hiddenSeries": false,
        "id": 38,
        "legend": {
          "avg": false,
          "current": false,
          "hideEmpty": true,
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
            "expr": "kafka_streams_stream_thread_metrics_commit_latency_max{thread_id=~\".+$clusterid.+\", " + hostSelector + "}",
            "format": "time_series",
            "instant": false,
            "interval": "",
            "legendFormat": "{{thread_id}}_avg",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Commit Latency (Max)",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "transformations": [],
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
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          },
          {
            "format": "short",
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": false
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
        "fill": 0,
        "fillGradient": 0,
        "gridPos": {
          "h": 11,
          "w": 6,
          "x": 12,
          "y": 44
        },
        "hiddenSeries": false,
        "id": 27,
        "legend": {
          "avg": false,
          "current": false,
          "hideEmpty": true,
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
            "expr": "kafka_streams_stream_thread_metrics_punctuate_latency_avg{thread_id=~\".+$clusterid.+\", " + hostSelector + "}",
            "format": "time_series",
            "instant": false,
            "interval": "",
            "legendFormat": "{{thread_id}}_avg",
            "refId": "A"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Punctuate Latency (Avg)",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "transformations": [],
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
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          },
          {
            "format": "short",
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": false
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
        "fill": 0,
        "fillGradient": 0,
        "gridPos": {
          "h": 11,
          "w": 6,
          "x": 18,
          "y": 44
        },
        "hiddenSeries": false,
        "id": 37,
        "legend": {
          "avg": false,
          "current": false,
          "hideEmpty": true,
          "max": false,
          "min": false,
          "show": true,
          "total": false,
          "values": false
        },
        "lines": true,
        "linewidth": 3,
        "nullPointMode": "null",
        "options": {
          "alertThreshold": true
        },
        "percentage": false,
        "pluginVersion": "7.5.6",
        "pointradius": 2,
        "points": false,
        "renderer": "flot",
        "seriesOverrides": [
          {
            "alias": "/max/",
            "dashLength": 5,
            "dashes": true,
            "spaceLength": 2
          }
        ],
        "spaceLength": 10,
        "stack": false,
        "steppedLine": false,
        "targets": [
          {
            "expr": "kafka_streams_stream_thread_metrics_punctuate_latency_max{thread_id=~\".+$clusterid.+\", " + hostSelector + "}",
            "interval": "",
            "legendFormat": "{{thread_id}}_max",
            "refId": "B"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Punctuate Latency (Max)",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "transformations": [],
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
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          },
          {
            "format": "short",
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": false
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
          "y": 55
        },
        "id": 40,
        "panels": [],
        "title": "StateStore Metric",
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
        "fill": 0,
        "fillGradient": 0,
        "gridPos": {
          "h": 11,
          "w": 6,
          "x": 0,
          "y": 56
        },
        "hiddenSeries": false,
        "id": 36,
        "legend": {
          "alignAsTable": true,
          "avg": true,
          "current": true,
          "hideEmpty": true,
          "max": true,
          "min": false,
          "show": true,
          "total": false,
          "values": true
        },
        "lines": true,
        "linewidth": 3,
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
            "expr": "kafka_streams_stream_state_metrics_put_rate{thread_id=~\".+$clusterid.+\", " + hostSelector + "}",
            "interval": "",
            "legendFormat": "{{thread_id}}",
            "refId": "B"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Put Rate",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "transformations": [],
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
            "label": "",
            "logBase": 1,
            "max": null,
            "min": "0",
            "show": true
          },
          {
            "format": "short",
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": false
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
        "fill": 0,
        "fillGradient": 0,
        "gridPos": {
          "h": 11,
          "w": 9,
          "x": 6,
          "y": 56
        },
        "hiddenSeries": false,
        "id": 42,
        "legend": {
          "alignAsTable": true,
          "avg": true,
          "current": true,
          "hideEmpty": true,
          "max": true,
          "min": false,
          "show": true,
          "total": false,
          "values": true
        },
        "lines": true,
        "linewidth": 3,
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
            "expr": "kafka_streams_stream_state_metrics_put_latency_avg{" + hostSelector + ",thread_id=~\".+$clusterid.+\"}",
            "interval": "",
            "legendFormat": "{{thread_id}}",
            "refId": "B"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Put average latency",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "transformations": [],
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
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          },
          {
            "format": "short",
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": false
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
        "fill": 0,
        "fillGradient": 0,
        "gridPos": {
          "h": 11,
          "w": 9,
          "x": 15,
          "y": 56
        },
        "hiddenSeries": false,
        "id": 43,
        "legend": {
          "alignAsTable": true,
          "avg": true,
          "current": true,
          "hideEmpty": true,
          "max": true,
          "min": false,
          "show": true,
          "total": false,
          "values": true
        },
        "lines": true,
        "linewidth": 3,
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
            "expr": "kafka_streams_stream_state_metrics_put_latency_max{" + hostSelector + ",thread_id=~\".+$clusterid.+\"}",
            "interval": "",
            "legendFormat": "{{thread_id}}",
            "refId": "B"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Put max latency",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "transformations": [],
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
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          },
          {
            "format": "short",
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": false
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
        "fill": 0,
        "fillGradient": 0,
        "gridPos": {
          "h": 11,
          "w": 6,
          "x": 0,
          "y": 67
        },
        "hiddenSeries": false,
        "id": 52,
        "legend": {
          "alignAsTable": true,
          "avg": true,
          "current": true,
          "hideEmpty": true,
          "max": true,
          "min": false,
          "show": true,
          "total": false,
          "values": true
        },
        "lines": true,
        "linewidth": 3,
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
            "expr": "kafka_streams_stream_state_metrics_put_if_absent_rate_rate{thread_id=~\".+$clusterid.+\", " + hostSelector + "}",
            "interval": "",
            "legendFormat": "{{thread_id}}",
            "refId": "B"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Put if absent rate",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "transformations": [],
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
            "label": "",
            "logBase": 1,
            "max": null,
            "min": "0",
            "show": true
          },
          {
            "format": "short",
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": false
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
        "fill": 0,
        "fillGradient": 0,
        "gridPos": {
          "h": 11,
          "w": 9,
          "x": 6,
          "y": 67
        },
        "hiddenSeries": false,
        "id": 53,
        "legend": {
          "alignAsTable": true,
          "avg": true,
          "current": true,
          "hideEmpty": true,
          "max": true,
          "min": false,
          "show": true,
          "total": false,
          "values": true
        },
        "lines": true,
        "linewidth": 3,
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
            "expr": "kafka_streams_stream_state_metrics_put_if_absent_latency_avg{" + hostSelector + ",thread_id=~\".+$clusterid.+\"}",
            "interval": "",
            "legendFormat": "{{thread_id}}",
            "refId": "B"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Put if absent average latency",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "transformations": [],
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
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          },
          {
            "format": "short",
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": false
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
        "fill": 0,
        "fillGradient": 0,
        "gridPos": {
          "h": 11,
          "w": 9,
          "x": 15,
          "y": 67
        },
        "hiddenSeries": false,
        "id": 54,
        "legend": {
          "alignAsTable": true,
          "avg": true,
          "current": true,
          "hideEmpty": true,
          "max": true,
          "min": false,
          "show": true,
          "total": false,
          "values": true
        },
        "lines": true,
        "linewidth": 3,
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
            "expr": "kafka_streams_stream_state_metrics_put_if_absent_latency_max{" + hostSelector + ",thread_id=~\".+$clusterid.+\"}",
            "interval": "",
            "legendFormat": "{{thread_id}}",
            "refId": "B"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Put if absent max latency",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "transformations": [],
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
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          },
          {
            "format": "short",
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": false
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
        "fill": 0,
        "fillGradient": 0,
        "gridPos": {
          "h": 11,
          "w": 6,
          "x": 0,
          "y": 78
        },
        "hiddenSeries": false,
        "id": 41,
        "legend": {
          "alignAsTable": true,
          "avg": true,
          "current": true,
          "hideEmpty": true,
          "max": true,
          "min": false,
          "show": true,
          "total": false,
          "values": true
        },
        "lines": true,
        "linewidth": 3,
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
            "expr": "kafka_streams_stream_state_metrics_fetch_rate{thread_id=~\".+$clusterid.+\", " + hostSelector + "}",
            "interval": "",
            "legendFormat": "{{thread_id}}",
            "refId": "B"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Fetch Rate",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "transformations": [],
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
            "label": "",
            "logBase": 1,
            "max": null,
            "min": "0",
            "show": true
          },
          {
            "format": "short",
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": false
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
        "fill": 0,
        "fillGradient": 0,
        "gridPos": {
          "h": 11,
          "w": 9,
          "x": 6,
          "y": 78
        },
        "hiddenSeries": false,
        "id": 44,
        "legend": {
          "alignAsTable": true,
          "avg": true,
          "current": true,
          "hideEmpty": true,
          "max": true,
          "min": false,
          "show": true,
          "total": false,
          "values": true
        },
        "lines": true,
        "linewidth": 3,
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
            "expr": "kafka_streams_stream_state_metrics_fetch_latency_avg{" + hostSelector + ",thread_id=~\".+$clusterid.+\"}",
            "interval": "",
            "legendFormat": "{{thread_id}}",
            "refId": "B"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Fetch average latency",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "transformations": [],
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
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          },
          {
            "format": "short",
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": false
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
        "fill": 0,
        "fillGradient": 0,
        "gridPos": {
          "h": 11,
          "w": 9,
          "x": 15,
          "y": 78
        },
        "hiddenSeries": false,
        "id": 45,
        "legend": {
          "alignAsTable": true,
          "avg": true,
          "current": true,
          "hideEmpty": true,
          "max": true,
          "min": false,
          "show": true,
          "total": false,
          "values": true
        },
        "lines": true,
        "linewidth": 3,
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
            "expr": "kafka_streams_stream_state_metrics_put_latency_max{" + hostSelector + ",thread_id=~\".+$clusterid.+\"}",
            "interval": "",
            "legendFormat": "{{thread_id}}",
            "refId": "B"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Fetch max latency",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "transformations": [],
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
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          },
          {
            "format": "short",
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": false
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
        "fill": 0,
        "fillGradient": 0,
        "gridPos": {
          "h": 11,
          "w": 6,
          "x": 0,
          "y": 89
        },
        "hiddenSeries": false,
        "id": 46,
        "legend": {
          "alignAsTable": true,
          "avg": true,
          "current": true,
          "hideEmpty": true,
          "max": true,
          "min": false,
          "show": true,
          "total": false,
          "values": true
        },
        "lines": true,
        "linewidth": 3,
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
            "expr": "kafka_streams_stream_state_metrics_delete_rate{thread_id=~\".+$clusterid.+\", " + hostSelector + "}",
            "interval": "",
            "legendFormat": "{{thread_id}}",
            "refId": "B"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Delete Rate",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "transformations": [],
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
            "label": "",
            "logBase": 1,
            "max": null,
            "min": "0",
            "show": true
          },
          {
            "format": "short",
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": false
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
        "fill": 0,
        "fillGradient": 0,
        "gridPos": {
          "h": 11,
          "w": 9,
          "x": 6,
          "y": 89
        },
        "hiddenSeries": false,
        "id": 47,
        "legend": {
          "alignAsTable": true,
          "avg": true,
          "current": true,
          "hideEmpty": true,
          "max": true,
          "min": false,
          "show": true,
          "total": false,
          "values": true
        },
        "lines": true,
        "linewidth": 3,
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
            "expr": "kafka_streams_stream_state_metrics_delete_latency_avg{" + hostSelector + ",thread_id=~\".+$clusterid.+\"}",
            "interval": "",
            "legendFormat": "{{thread_id}}",
            "refId": "B"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Delete average latency",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "transformations": [],
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
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          },
          {
            "format": "short",
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": false
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
        "fill": 0,
        "fillGradient": 0,
        "gridPos": {
          "h": 11,
          "w": 9,
          "x": 15,
          "y": 89
        },
        "hiddenSeries": false,
        "id": 48,
        "legend": {
          "alignAsTable": true,
          "avg": true,
          "current": true,
          "hideEmpty": true,
          "max": true,
          "min": false,
          "show": true,
          "total": false,
          "values": true
        },
        "lines": true,
        "linewidth": 3,
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
            "expr": "kafka_streams_stream_state_metrics_delete_latency_max{" + hostSelector + ",thread_id=~\".+$clusterid.+\"}",
            "interval": "",
            "legendFormat": "{{thread_id}}",
            "refId": "B"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Delete max latency",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "transformations": [],
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
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          },
          {
            "format": "short",
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": false
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
        "fill": 0,
        "fillGradient": 0,
        "gridPos": {
          "h": 11,
          "w": 6,
          "x": 0,
          "y": 100
        },
        "hiddenSeries": false,
        "id": 49,
        "legend": {
          "alignAsTable": true,
          "avg": true,
          "current": true,
          "hideEmpty": true,
          "max": true,
          "min": false,
          "show": true,
          "total": false,
          "values": true
        },
        "lines": true,
        "linewidth": 3,
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
            "expr": "kafka_streams_stream_state_metrics_restore_rate{thread_id=~\".+$clusterid.+\", " + hostSelector + "}",
            "interval": "",
            "legendFormat": "{{thread_id}}",
            "refId": "B"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Restore Rate",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "transformations": [],
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
            "label": "",
            "logBase": 1,
            "max": null,
            "min": "0",
            "show": true
          },
          {
            "format": "short",
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": false
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
        "fill": 0,
        "fillGradient": 0,
        "gridPos": {
          "h": 11,
          "w": 9,
          "x": 6,
          "y": 100
        },
        "hiddenSeries": false,
        "id": 50,
        "legend": {
          "alignAsTable": true,
          "avg": true,
          "current": true,
          "hideEmpty": true,
          "max": true,
          "min": false,
          "show": true,
          "total": false,
          "values": true
        },
        "lines": true,
        "linewidth": 3,
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
            "expr": "kafka_streams_stream_state_metrics_restore_latency_avg{" + hostSelector + ",thread_id=~\".+$clusterid.+\"}",
            "interval": "",
            "legendFormat": "{{thread_id}}",
            "refId": "B"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Restore average latency",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "transformations": [],
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
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          },
          {
            "format": "short",
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": false
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
        "fill": 0,
        "fillGradient": 0,
        "gridPos": {
          "h": 11,
          "w": 9,
          "x": 15,
          "y": 100
        },
        "hiddenSeries": false,
        "id": 51,
        "legend": {
          "alignAsTable": true,
          "avg": true,
          "current": true,
          "hideEmpty": true,
          "max": true,
          "min": false,
          "show": true,
          "total": false,
          "values": true
        },
        "lines": true,
        "linewidth": 3,
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
            "expr": "kafka_streams_stream_state_metrics_restore_latency_max{" + hostSelector + ",thread_id=~\".+$clusterid.+\"}",
            "interval": "",
            "legendFormat": "{{thread_id}}",
            "refId": "B"
          }
        ],
        "thresholds": [],
        "timeFrom": null,
        "timeRegions": [],
        "timeShift": null,
        "title": "Restore max latency",
        "tooltip": {
          "shared": true,
          "sort": 0,
          "value_type": "individual"
        },
        "transformations": [],
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
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": true
          },
          {
            "format": "short",
            "label": "",
            "logBase": 1,
            "max": null,
            "min": null,
            "show": false
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
          "queryValue": "",
          "refresh": 2,
          "regex": "",
          "skipUrlSync": false,
          "type": "datasource"
        },
        {
          "allValue": ".+",
          "current": {},
          "datasource": "$datasource",
          "definition": "label_values(ksql_ksql_engine_query_stats_liveness_indicator{" + filterSelector + "}, job)",
          "description": null,
          "error": null,
          "hide": 0,
          "includeAll": true,
          "label": "Job",
          "multi": true,
          "name": "job",
          "options": [],
          "query": {
            "query": "label_values(ksql_ksql_engine_query_stats_liveness_indicator{" + filterSelector + "}, job)",
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
          "definition": "label_values(kafka_log_log_size{" + jobSelector + "}, kafka_cluster)",
          "description": null,
          "error": null,
          "hide": 0,
          "includeAll": true,
          "label": "Kafka Cluster",
          "multi": true,
          "name": "kafka_cluster",
          "options": [],
          "query": {
            "query": "label_values(kafka_log_log_size{" + jobSelector + "}, kafka_cluster)",
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
          "definition": "label_values(ksql_ksql_engine_query_stats_liveness_indicator{" + jobSelector + "},ksql_cluster)",
          "description": null,
          "error": null,
          "hide": 0,
          "includeAll": true,
          "label": "KSQL Cluster",
          "multi": true,
          "name": "clusterid",
          "options": [],
          "query": {
            "query": "label_values(ksql_ksql_engine_query_stats_liveness_indicator{" + jobSelector + "},ksql_cluster)",
            "refId": "Cortex-clusterid-Variable-Query"
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
          "definition": "label_values(ksql_ksql_engine_query_stats_liveness_indicator{" + jobSelector + ", " + kafkaClusterSelector + ", ksql_cluster=\"$ksql_cluster\"},instance)",
          "description": null,
          "error": null,
          "hide": 0,
          "includeAll": true,
          "label": "Instance",
          "multi": true,
          "name": "instance",
          "options": [],
          "query": {
            "query": "label_values(ksql_ksql_engine_query_stats_liveness_indicator{" + jobSelector + ", " + kafkaClusterSelector + ", ksql_cluster=\"$ksql_cluster\"},instance)",
            "refId": "Cortex-instance-Variable-Query"
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
      "from": "now-1h",
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
      ]
    },
    "timezone": "",
    "title": "ksqldb Overview",
    "uid": "pbx34foGk",
    "version": 3
  };

{
  grafanaDashboards+::
  {
    'ksqldb-overview.json': dashboard
  }
}

