local config = (import '../config.libsonnet');
local filterSelector = "job=~\"integrations/kafka-zookeeper|integrations/kafka\"";
local hostSelector = config._config.HostSelector;
local jobSelector = config._config.JobSelector;
local kafkaClusterSelector = config._config.KafkaClusterSelector;

local dashboard =
  {
    "annotations": {
      "list": [
        {
          "builtIn": 1,
          "datasource": {
            "type": "datasource",
            "uid": "grafana"
          },
          "enable": true,
          "hide": true,
          "iconColor": "rgba(0, 211, 255, 1)",
          "name": "Annotations & Alerts",
          "target": {
            "limit": 100,
            "matchAny": false,
            "tags": [],
            "type": "dashboard"
          },
          "type": "dashboard"
        }
      ]
    },
    "editable": true,
    "fiscalYearStartMonth": 0,
    "graphTooltip": 0,
    "id": 125,
    "links": [],
    "liveNow": false,
    "panels": [
      {
        "collapsed": false,
        "datasource": {
          "type": "prometheus",
          "uid": "${datasource}"
        },
        "gridPos": {
          "h": 1,
          "w": 24,
          "x": 0,
          "y": 0
        },
        "id": 22,
        "panels": [],
        "targets": [
          {
            "datasource": {
              "type": "prometheus",
              "uid": "PC7A11E9A55DE2B14"
            },
            "refId": "A"
          }
        ],
        "title": "Health check",
        "type": "row"
      },
      {
        "datasource": {
          "type": "prometheus",
          "uid": "${datasource}"
        },
        "description": "Quorum size of zookeeper ensemble or number of nodes online for single instance deployments",
        "fieldConfig": {
          "defaults": {
            "color": {
              "mode": "thresholds"
            },
            "mappings": [
              {
                "options": {
                  "match": "null",
                  "result": {
                    "text": "N/A"
                  }
                },
                "type": "special"
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
                  "value": 2
                },
                {
                  "color": "#299c46",
                  "value": 3
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
        "id": 2,
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
          "textMode": "auto"
        },
        "pluginVersion": "9.4.3",
        "targets": [
          {
            "datasource": {
              "uid": "${datasource}"
            },
            "editorMode": "code",
            "exemplar": true,
            "expr": "# kafka operator case\ncount(zookeeper_quorumsize{" + hostSelector + "})\n# kafka grafana cloud integration case\nor count(zookeeper_status_quorumsize{" + hostSelector + "})\n# or single instance case (non-cluster)\nor count(up{" + hostSelector + "} == 1)",
            "interval": "",
            "legendFormat": "",
            "range": true,
            "refId": "A"
          }
        ],
        "title": "Zookeeper nodes online",
        "type": "stat"
      },
      {
        "datasource": {
          "type": "prometheus",
          "uid": "${datasource}"
        },
        "description": "Number of alive connections",
        "fieldConfig": {
          "defaults": {
            "color": {
              "mode": "thresholds"
            },
            "mappings": [
              {
                "options": {
                  "match": "null",
                  "result": {
                    "text": "N/A"
                  }
                },
                "type": "special"
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
                  "value": 100
                },
                {
                  "color": "#d44a3a",
                  "value": 200
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
        "id": 4,
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
          "textMode": "auto"
        },
        "pluginVersion": "9.4.3",
        "targets": [
          {
            "datasource": {
              "uid": "${datasource}"
            },
            "editorMode": "code",
            "exemplar": true,
            "expr": "sum(zookeeper_numaliveconnections{" + hostSelector + "})",
            "interval": "",
            "legendFormat": "",
            "range": true,
            "refId": "A"
          }
        ],
        "title": "Alive connections",
        "type": "stat"
      },
      {
        "datasource": {
          "type": "prometheus",
          "uid": "${datasource}"
        },
        "description": "Number of queued requests in the server. This goes up when the server receives more requests than it can process",
        "fieldConfig": {
          "defaults": {
            "color": {
              "mode": "palette-classic"
            },
            "custom": {
              "axisCenteredZero": false,
              "axisColorMode": "text",
              "axisLabel": "",
              "axisPlacement": "auto",
              "barAlignment": 0,
              "drawStyle": "line",
              "fillOpacity": 10,
              "gradientMode": "none",
              "hideFrom": {
                "legend": false,
                "tooltip": false,
                "viz": false
              },
              "lineInterpolation": "linear",
              "lineWidth": 1,
              "pointSize": 5,
              "scaleDistribution": {
                "type": "linear"
              },
              "showPoints": "never",
              "spanNulls": false,
              "stacking": {
                "group": "A",
                "mode": "none"
              },
              "thresholdsStyle": {
                "mode": "dashed"
              }
            },
            "decimals": 0,
            "links": [],
            "mappings": [],
            "min": 0,
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {
                  "color": "transparent",
                  "value": null
                },
                {
                  "color": "red",
                  "value": 10
                }
              ]
            },
            "unit": "short"
          },
          "overrides": []
        },
        "gridPos": {
          "h": 8,
          "w": 16,
          "x": 8,
          "y": 1
        },
        "id": 7,
        "options": {
          "legend": {
            "calcs": [
              "mean",
              "lastNotNull",
              "max"
            ],
            "displayMode": "table",
            "placement": "bottom",
            "showLegend": true
          },
          "tooltip": {
            "mode": "multi",
            "sort": "none"
          }
        },
        "pluginVersion": "9.4.3",
        "targets": [
          {
            "datasource": {
              "uid": "${datasource}"
            },
            "editorMode": "code",
            "exemplar": true,
            "expr": "zookeeper_outstandingrequests{" + hostSelector + "}",
            "interval": "",
            "legendFormat": "{{server_name}}:({{instance}})",
            "range": true,
            "refId": "A"
          }
        ],
        "title": "Outstanding requests",
        "type": "timeseries"
      },
      {
        "datasource": {
          "uid": "${datasource}"
        },
        "description": "",
        "fieldConfig": {
          "defaults": {
            "color": {
              "mode": "thresholds"
            },
            "mappings": [
              {
                "options": {
                  "match": "null",
                  "result": {
                    "text": "N/A"
                  }
                },
                "type": "special"
              }
            ],
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
        "id": 3,
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
          "textMode": "auto"
        },
        "pluginVersion": "9.4.3",
        "targets": [
          {
            "datasource": {
              "uid": "${datasource}"
            },
            "exemplar": true,
            "expr": "avg(zookeeper_inmemorydatatree_nodecount{" + hostSelector + "})",
            "interval": "",
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "title": "Number of ZNodes",
        "type": "stat"
      },
      {
        "datasource": {
          "uid": "${datasource}"
        },
        "description": "Number of watchers",
        "fieldConfig": {
          "defaults": {
            "color": {
              "mode": "thresholds"
            },
            "mappings": [
              {
                "options": {
                  "match": "null",
                  "result": {
                    "text": "N/A"
                  }
                },
                "type": "special"
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
                  "value": 1000
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
        "id": 5,
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
          "textMode": "auto"
        },
        "pluginVersion": "9.4.3",
        "targets": [
          {
            "datasource": {
              "uid": "${datasource}"
            },
            "exemplar": true,
            "expr": "sum(zookeeper_inmemorydatatree_watchcount{" + hostSelector + "})",
            "interval": "",
            "legendFormat": "",
            "refId": "A"
          }
        ],
        "title": "Number of watchers",
        "type": "stat"
      },
      {
        "datasource": {
          "type": "prometheus",
          "uid": "PC7A11E9A55DE2B14"
        },
        "gridPos": {
          "h": 1,
          "w": 24,
          "x": 0,
          "y": 9
        },
        "id": 20,
        "targets": [
          {
            "datasource": {
              "type": "prometheus",
              "uid": "PC7A11E9A55DE2B14"
            },
            "refId": "A"
          }
        ],
        "title": "System",
        "type": "row"
      },
      {
        "datasource": {
          "type": "prometheus",
          "uid": "${datasource}"
        },
        "description": "",
        "fieldConfig": {
          "defaults": {
            "color": {
              "mode": "palette-classic"
            },
            "custom": {
              "axisCenteredZero": false,
              "axisColorMode": "text",
              "axisLabel": "",
              "axisPlacement": "auto",
              "barAlignment": 0,
              "drawStyle": "line",
              "fillOpacity": 10,
              "gradientMode": "none",
              "hideFrom": {
                "legend": false,
                "tooltip": false,
                "viz": false
              },
              "lineInterpolation": "linear",
              "lineWidth": 1,
              "pointSize": 5,
              "scaleDistribution": {
                "type": "linear"
              },
              "showPoints": "never",
              "spanNulls": false,
              "stacking": {
                "group": "A",
                "mode": "none"
              },
              "thresholdsStyle": {
                "mode": "off"
              }
            },
            "links": [],
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
            },
            "unit": "percent"
          },
          "overrides": []
        },
        "gridPos": {
          "h": 7,
          "w": 8,
          "x": 0,
          "y": 10
        },
        "id": 12,
        "options": {
          "legend": {
            "calcs": [
              "mean",
              "lastNotNull",
              "max"
            ],
            "displayMode": "table",
            "placement": "bottom",
            "showLegend": true
          },
          "tooltip": {
            "mode": "multi",
            "sort": "none"
          }
        },
        "pluginVersion": "9.4.3",
        "targets": [
          {
            "datasource": {
              "uid": "${datasource}"
            },
            "editorMode": "code",
            "exemplar": true,
            "expr": "# for strimzi operator: remove kafka container java metrics \nirate(process_cpu_seconds_total{" + hostSelector + ", container!=\"kafka\"}[$__rate_interval])*100",
            "interval": "",
            "legendFormat": "{{instance}}",
            "range": true,
            "refId": "A"
          }
        ],
        "title": "CPU usage",
        "type": "timeseries"
      },
      {
        "datasource": {
          "type": "prometheus",
          "uid": "${datasource}"
        },
        "description": "",
        "fieldConfig": {
          "defaults": {
            "color": {
              "mode": "palette-classic"
            },
            "custom": {
              "axisCenteredZero": false,
              "axisColorMode": "text",
              "axisLabel": "",
              "axisPlacement": "auto",
              "barAlignment": 0,
              "drawStyle": "line",
              "fillOpacity": 10,
              "gradientMode": "none",
              "hideFrom": {
                "legend": false,
                "tooltip": false,
                "viz": false
              },
              "lineInterpolation": "linear",
              "lineWidth": 1,
              "pointSize": 5,
              "scaleDistribution": {
                "type": "linear"
              },
              "showPoints": "never",
              "spanNulls": false,
              "stacking": {
                "group": "A",
                "mode": "none"
              },
              "thresholdsStyle": {
                "mode": "off"
              }
            },
            "links": [],
            "mappings": [],
            "min": 0,
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
            },
            "unit": "bytes"
          },
          "overrides": []
        },
        "gridPos": {
          "h": 7,
          "w": 8,
          "x": 8,
          "y": 10
        },
        "id": 13,
        "options": {
          "legend": {
            "calcs": [
              "mean",
              "lastNotNull",
              "max"
            ],
            "displayMode": "table",
            "placement": "bottom",
            "showLegend": true
          },
          "tooltip": {
            "mode": "multi",
            "sort": "none"
          }
        },
        "pluginVersion": "9.4.3",
        "targets": [
          {
            "datasource": {
              "uid": "${datasource}"
            },
            "editorMode": "code",
            "exemplar": true,
            "expr": "sum without(area)(jvm_memory_bytes_used{" + hostSelector + ", container!=\"kafka\"})",
            "interval": "",
            "legendFormat": "Used:{{instance}}",
            "range": true,
            "refId": "A"
          },
          {
            "datasource": {
              "uid": "${datasource}"
            },
            "editorMode": "code",
            "exemplar": true,
            "expr": "jvm_memory_bytes_max{" + hostSelector + ",area=\"heap\", container!=\"kafka\"}",
            "interval": "",
            "legendFormat": "Max:{{instance}}",
            "range": true,
            "refId": "B"
          }
        ],
        "title": "JVM memory used",
        "type": "timeseries"
      },
      {
        "datasource": {
          "type": "prometheus",
          "uid": "${datasource}"
        },
        "description": "",
        "fieldConfig": {
          "defaults": {
            "color": {
              "mode": "palette-classic"
            },
            "custom": {
              "axisCenteredZero": false,
              "axisColorMode": "text",
              "axisLabel": "",
              "axisPlacement": "auto",
              "barAlignment": 0,
              "drawStyle": "line",
              "fillOpacity": 10,
              "gradientMode": "none",
              "hideFrom": {
                "legend": false,
                "tooltip": false,
                "viz": false
              },
              "lineInterpolation": "linear",
              "lineWidth": 1,
              "pointSize": 5,
              "scaleDistribution": {
                "type": "linear"
              },
              "showPoints": "never",
              "spanNulls": false,
              "stacking": {
                "group": "A",
                "mode": "none"
              },
              "thresholdsStyle": {
                "mode": "off"
              }
            },
            "decimals": 3,
            "links": [],
            "mappings": [],
            "min": 0,
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
            },
            "unit": "percentunit"
          },
          "overrides": []
        },
        "gridPos": {
          "h": 7,
          "w": 8,
          "x": 16,
          "y": 10
        },
        "id": 14,
        "options": {
          "legend": {
            "calcs": [
              "mean",
              "lastNotNull",
              "max"
            ],
            "displayMode": "table",
            "placement": "bottom",
            "showLegend": true
          },
          "tooltip": {
            "mode": "multi",
            "sort": "none"
          }
        },
        "pluginVersion": "9.4.3",
        "targets": [
          {
            "datasource": {
              "uid": "${datasource}"
            },
            "editorMode": "code",
            "exemplar": true,
            "expr": "# for strimzi operator: remove kafka container java metrics\nsum without(gc)(rate(jvm_gc_collection_seconds_sum{" + hostSelector + ", container!=\"kafka\" }[$__rate_interval]))",
            "interval": "",
            "legendFormat": "{{instance}}",
            "range": true,
            "refId": "A"
          }
        ],
        "title": "Time spent in GC",
        "type": "timeseries"
      },
      {
        "collapsed": false,
        "datasource": {
          "type": "prometheus",
          "uid": "PC7A11E9A55DE2B14"
        },
        "gridPos": {
          "h": 1,
          "w": 24,
          "x": 0,
          "y": 17
        },
        "id": 18,
        "panels": [],
        "targets": [
          {
            "datasource": {
              "type": "prometheus",
              "uid": "PC7A11E9A55DE2B14"
            },
            "refId": "A"
          }
        ],
        "title": "Request latency",
        "type": "row"
      },
      {
        "datasource": {
          "type": "prometheus",
          "uid": "${datasource}"
        },
        "description": "Amount of time it takes for the server to respond to a client request",
        "fieldConfig": {
          "defaults": {
            "color": {
              "mode": "palette-classic"
            },
            "custom": {
              "axisCenteredZero": false,
              "axisColorMode": "text",
              "axisLabel": "",
              "axisPlacement": "auto",
              "barAlignment": 0,
              "drawStyle": "line",
              "fillOpacity": 10,
              "gradientMode": "none",
              "hideFrom": {
                "legend": false,
                "tooltip": false,
                "viz": false
              },
              "lineInterpolation": "linear",
              "lineWidth": 1,
              "pointSize": 5,
              "scaleDistribution": {
                "type": "linear"
              },
              "showPoints": "never",
              "spanNulls": false,
              "stacking": {
                "group": "A",
                "mode": "none"
              },
              "thresholdsStyle": {
                "mode": "off"
              }
            },
            "decimals": 0,
            "links": [],
            "mappings": [],
            "min": 0,
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
            },
            "unit": "ms"
          },
          "overrides": []
        },
        "gridPos": {
          "h": 7,
          "w": 8,
          "x": 0,
          "y": 18
        },
        "id": 9,
        "options": {
          "legend": {
            "calcs": [],
            "displayMode": "list",
            "placement": "bottom",
            "showLegend": true
          },
          "tooltip": {
            "mode": "multi",
            "sort": "none"
          }
        },
        "pluginVersion": "9.4.3",
        "targets": [
          {
            "datasource": {
              "uid": "${datasource}"
            },
            "editorMode": "code",
            "exemplar": true,
            "expr": "zookeeper_minrequestlatency{" + hostSelector + "} * ignoring (minrequestlatency,ticktime)zookeeper_ticktime{" + hostSelector + "}",
            "interval": "",
            "legendFormat": "{{server_name}}:({{instance}})",
            "range": true,
            "refId": "A"
          }
        ],
        "title": "Request latency - min",
        "type": "timeseries"
      },
      {
        "datasource": {
          "type": "prometheus",
          "uid": "${datasource}"
        },
        "description": "Amount of time it takes for the server to respond to a client request",
        "fieldConfig": {
          "defaults": {
            "color": {
              "mode": "palette-classic"
            },
            "custom": {
              "axisCenteredZero": false,
              "axisColorMode": "text",
              "axisLabel": "",
              "axisPlacement": "auto",
              "barAlignment": 0,
              "drawStyle": "line",
              "fillOpacity": 10,
              "gradientMode": "none",
              "hideFrom": {
                "legend": false,
                "tooltip": false,
                "viz": false
              },
              "lineInterpolation": "linear",
              "lineWidth": 1,
              "pointSize": 5,
              "scaleDistribution": {
                "type": "linear"
              },
              "showPoints": "never",
              "spanNulls": false,
              "stacking": {
                "group": "A",
                "mode": "none"
              },
              "thresholdsStyle": {
                "mode": "line+area"
              }
            },
            "decimals": 0,
            "links": [],
            "mappings": [],
            "min": 0,
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {
                  "color": "transparent",
                  "value": null
                },
                {
                  "color": "red",
                  "value": 12000
                }
              ]
            },
            "unit": "ms"
          },
          "overrides": []
        },
        "gridPos": {
          "h": 7,
          "w": 8,
          "x": 8,
          "y": 18
        },
        "id": 10,
        "options": {
          "legend": {
            "calcs": [],
            "displayMode": "list",
            "placement": "bottom",
            "showLegend": true
          },
          "tooltip": {
            "mode": "multi",
            "sort": "none"
          }
        },
        "pluginVersion": "9.4.3",
        "targets": [
          {
            "datasource": {
              "uid": "${datasource}"
            },
            "editorMode": "code",
            "exemplar": true,
            "expr": "zookeeper_avgrequestlatency{" + hostSelector + "} * ignoring (avgrequestlatency,ticktime) zookeeper_ticktime{" + hostSelector + "}",
            "interval": "",
            "legendFormat": "{{server_name}}:({{instance}})",
            "range": true,
            "refId": "A"
          }
        ],
        "title": "Request latency - average",
        "type": "timeseries"
      },
      {
        "datasource": {
          "type": "prometheus",
          "uid": "${datasource}"
        },
        "description": "Amount of time it takes for the server to respond to a client request",
        "fieldConfig": {
          "defaults": {
            "color": {
              "mode": "palette-classic"
            },
            "custom": {
              "axisCenteredZero": false,
              "axisColorMode": "text",
              "axisLabel": "",
              "axisPlacement": "auto",
              "barAlignment": 0,
              "drawStyle": "line",
              "fillOpacity": 10,
              "gradientMode": "none",
              "hideFrom": {
                "legend": false,
                "tooltip": false,
                "viz": false
              },
              "lineInterpolation": "linear",
              "lineWidth": 1,
              "pointSize": 5,
              "scaleDistribution": {
                "type": "linear"
              },
              "showPoints": "never",
              "spanNulls": false,
              "stacking": {
                "group": "A",
                "mode": "none"
              },
              "thresholdsStyle": {
                "mode": "off"
              }
            },
            "links": [],
            "mappings": [],
            "min": 0,
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
            },
            "unit": "ms"
          },
          "overrides": []
        },
        "gridPos": {
          "h": 7,
          "w": 8,
          "x": 16,
          "y": 18
        },
        "id": 11,
        "options": {
          "legend": {
            "calcs": [],
            "displayMode": "list",
            "placement": "bottom",
            "showLegend": true
          },
          "tooltip": {
            "mode": "multi",
            "sort": "none"
          }
        },
        "pluginVersion": "9.4.3",
        "targets": [
          {
            "datasource": {
              "uid": "${datasource}"
            },
            "editorMode": "code",
            "exemplar": true,
            "expr": "zookeeper_maxrequestlatency{" + hostSelector + "} * ignoring (maxrequestlatency,ticktime)\n zookeeper_ticktime{" + hostSelector + "}",
            "interval": "",
            "legendFormat": "{{server_name}}:({{instance}})",
            "range": true,
            "refId": "A"
          }
        ],
        "title": "Request latency - max",
        "type": "timeseries"
      }
    ],
    "refresh": "30s",
    "revision": 1,
    "schemaVersion": 38,
    "style": "dark",
    "tags": [
      "kafka"
    ],
    "templating": {
      "list": [
        {
          "hide": 0,
          "includeAll": false,
          "label": "Data source",
          "multi": false,
          "name": "datasource",
          "options": [],
          "query": "prometheus",
          "refresh": 1,
          "regex": ".+",
          "skipUrlSync": false,
          "type": "datasource"
        },
        {
          "allValue": ".+",
          "datasource": {
            "uid": "$datasource"
          },
          "definition": "label_values(zookeeper_outstandingrequests{" + filterSelector + "}, job)",
          "hide": 0,
          "includeAll": false,
          "label": "Job",
          "multi": true,
          "name": "job",
          "options": [],
          "query": {
            "query": "label_values(zookeeper_outstandingrequests{" + filterSelector + "}, job)",
            "refId": "StandardVariableQuery"
          },
          "refresh": 2,
          "regex": "",
          "skipUrlSync": false,
          "sort": 0,
          "tagValuesQuery": "",
          "tagsQuery": "",
          "type": "query",
          "useTags": false
        },
        {
          "allValue": ".+",
          "current": {},
          "datasource": "${datasource}",
          "definition": "label_values(zookeeper_outstandingrequests{" + jobSelector + "}, kafka_cluster)",
          "description": null,
          "error": null,
          "hide": 0,
          "includeAll": true,
          "label": "Kafka Cluster",
          "multi": true,
          "name": "kafka_cluster",
          "options": [],
          "query": {
            "query": "label_values(zookeeper_outstandingrequests{" + jobSelector + "}, kafka_cluster)",
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
            "selected": true,
            "text": [
              "All"
            ],
            "value": [
              "$__all"
            ]
          },
          "datasource": {
            "uid": "${datasource}"
          },
          "definition": "label_values(zookeeper_outstandingrequests{" + jobSelector + ", " + kafkaClusterSelector + "},instance)",
          "hide": 0,
          "includeAll": true,
          "label": "Instance",
          "multi": true,
          "name": "instance",
          "options": [],
          "query": {
            "query": "label_values(zookeeper_outstandingrequests{" + jobSelector + ", " + kafkaClusterSelector + "},instance)",
            "refId": "StandardVariableQuery"
          },
          "refresh": 2,
          "regex": "",
          "skipUrlSync": false,
          "sort": 0,
          "tagValuesQuery": "",
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
    "title": "Zookeeper overview",
    "uid": "H4xS98vWk",
    "version": 12,
    "weekStart": ""
  };

{
  grafanaDashboards+::
  {
    'zookeeper-overview.json': dashboard
  }
}
