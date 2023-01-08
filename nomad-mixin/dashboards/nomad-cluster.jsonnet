{
  grafanaDashboards+:: {
    'nomad-cluster.json':
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
        "graphTooltip": 1,
        "id": 8,
        "links": [],
        "liveNow": false,
        "panels": [
          {
            "datasource": {
              "type": "prometheus",
              "uid": "grafanacloud-prom"
            },
            "gridPos": {
              "h": 1,
              "w": 24,
              "x": 0,
              "y": 0
            },
            "id": 24,
            "targets": [
              {
                "datasource": {
                  "type": "prometheus",
                  "uid": "grafanacloud-prom"
                },
                "refId": "A"
              }
            ],
            "title": "Allocations",
            "type": "row"
          },
          {
            "datasource": {
              "uid": "$datasource"
            },
            "description": "CPU allocated on $instance",
            "fieldConfig": {
              "defaults": {
                "color": {
                  "mode": "thresholds"
                },
                "mappings": [],
                "max": 100,
                "min": 0,
                "thresholds": {
                  "mode": "absolute",
                  "steps": [
                    {
                      "color": "green",
                      "value": null
                    },
                    {
                      "color": "yellow",
                      "value": 80
                    },
                    {
                      "color": "red",
                      "value": 90
                    }
                  ]
                },
                "unit": "percent"
              },
              "overrides": []
            },
            "gridPos": {
              "h": 5,
              "w": 5,
              "x": 0,
              "y": 1
            },
            "id": 33,
            "links": [],
            "maxDataPoints": 100,
            "options": {
              "orientation": "horizontal",
              "reduceOptions": {
                "calcs": [
                  "lastNotNull"
                ],
                "fields": "",
                "values": false
              },
              "showThresholdLabels": false,
              "showThresholdMarkers": true,
              "text": {}
            },
            "pluginVersion": "9.3.2",
            "repeat": "instance",
            "repeatDirection": "v",
            "targets": [
              {
                "datasource": {
                  "uid": "$datasource"
                },
                "expr": "nomad_client_allocated_cpu{job=~\"$job\", datacenter=~\"$datacenter\", instance=~\"$instance\"}/(nomad_client_unallocated_cpu{job=~\"$job\", datacenter=~\"$datacenter\", instance=~\"$instance\"}+nomad_client_allocated_cpu{job=~\"$job\", datacenter=~\"$datacenter\", instance=~\"$instance\"})*100",
                "format": "time_series",
                "interval": "",
                "intervalFactor": 1,
                "legendFormat": "",
                "refId": "A"
              }
            ],
            "title": "CPU allocated",
            "type": "gauge"
          },
          {
            "datasource": {
              "uid": "$datasource"
            },
            "description": "Memory allocated on $instance",
            "fieldConfig": {
              "defaults": {
                "color": {
                  "mode": "thresholds"
                },
                "mappings": [],
                "max": 100,
                "min": 0,
                "thresholds": {
                  "mode": "absolute",
                  "steps": [
                    {
                      "color": "green",
                      "value": null
                    },
                    {
                      "color": "yellow",
                      "value": 80
                    },
                    {
                      "color": "red",
                      "value": 90
                    }
                  ]
                },
                "unit": "percent"
              },
              "overrides": []
            },
            "gridPos": {
              "h": 5,
              "w": 5,
              "x": 5,
              "y": 1
            },
            "id": 40,
            "links": [],
            "maxDataPoints": 100,
            "options": {
              "orientation": "horizontal",
              "reduceOptions": {
                "calcs": [
                  "lastNotNull"
                ],
                "fields": "",
                "values": false
              },
              "showThresholdLabels": false,
              "showThresholdMarkers": true,
              "text": {}
            },
            "pluginVersion": "9.3.2",
            "repeat": "instance",
            "repeatDirection": "v",
            "targets": [
              {
                "datasource": {
                  "uid": "$datasource"
                },
                "expr": "nomad_client_allocated_memory{job=~\"$job\", datacenter=~\"$datacenter\", instance=~\"$instance\"}/(nomad_client_unallocated_memory{job=~\"$job\", datacenter=~\"$datacenter\", instance=~\"$instance\"}+nomad_client_allocated_memory{job=~\"$job\", datacenter=~\"$datacenter\", instance=~\"$instance\"})*100",
                "format": "time_series",
                "interval": "",
                "intervalFactor": 1,
                "legendFormat": "",
                "refId": "A"
              }
            ],
            "title": "Memory allocated",
            "type": "gauge"
          },
          {
            "datasource": {
              "uid": "$datasource"
            },
            "description": "Disk allocated on $instance",
            "fieldConfig": {
              "defaults": {
                "color": {
                  "mode": "thresholds"
                },
                "decimals": 2,
                "mappings": [],
                "max": 100,
                "min": 0,
                "thresholds": {
                  "mode": "absolute",
                  "steps": [
                    {
                      "color": "green",
                      "value": null
                    },
                    {
                      "color": "yellow",
                      "value": 80
                    },
                    {
                      "color": "red",
                      "value": 90
                    }
                  ]
                },
                "unit": "percent"
              },
              "overrides": []
            },
            "gridPos": {
              "h": 5,
              "w": 5,
              "x": 10,
              "y": 1
            },
            "id": 48,
            "links": [],
            "maxDataPoints": 100,
            "options": {
              "orientation": "horizontal",
              "reduceOptions": {
                "calcs": [
                  "lastNotNull"
                ],
                "fields": "",
                "values": false
              },
              "showThresholdLabels": false,
              "showThresholdMarkers": true,
              "text": {}
            },
            "pluginVersion": "9.3.2",
            "repeat": "instance",
            "repeatDirection": "v",
            "targets": [
              {
                "datasource": {
                  "uid": "$datasource"
                },
                "expr": "nomad_client_allocated_disk{job=~\"$job\", datacenter=~\"$datacenter\", instance=~\"$instance\"}/(nomad_client_unallocated_disk{job=~\"$job\", datacenter=~\"$datacenter\", instance=~\"$instance\"}+nomad_client_allocated_disk{job=~\"$job\", datacenter=~\"$datacenter\", instance=~\"$instance\"})*100",
                "format": "time_series",
                "interval": "",
                "intervalFactor": 1,
                "legendFormat": "",
                "refId": "A"
              }
            ],
            "title": "Disk allocated",
            "type": "gauge"
          },
          {
            "datasource": {
              "type": "prometheus",
              "uid": "${datasource}"
            },
            "fieldConfig": {
              "defaults": {
                "color": {
                  "mode": "continuous-GrYlRd"
                },
                "custom": {
                  "fillOpacity": 70,
                  "lineWidth": 1,
                  "spanNulls": false
                },
                "mappings": [],
                "thresholds": {
                  "mode": "absolute",
                  "steps": [
                    {
                      "color": "green",
                      "value": null
                    }
                  ]
                },
                "unit": "allocs"
              },
              "overrides": []
            },
            "gridPos": {
              "h": 5,
              "w": 9,
              "x": 15,
              "y": 1
            },
            "id": 58,
            "links": [],
            "options": {
              "alignValue": "left",
              "legend": {
                "displayMode": "list",
                "placement": "bottom",
                "showLegend": false
              },
              "mergeValues": true,
              "rowHeight": 0.95,
              "showValue": "auto",
              "tooltip": {
                "mode": "single",
                "sort": "none"
              }
            },
            "repeat": "instance",
            "repeatDirection": "v",
            "targets": [
              {
                "datasource": {
                  "type": "prometheus",
                  "uid": "${datasource}"
                },
                "exemplar": true,
                "expr": "sum by (datacenter) (nomad_client_allocations_migrating{job=~\"$job\", datacenter=~\"$datacenter\", instance=~\"$instance\"})",
                "format": "time_series",
                "interval": "",
                "intervalFactor": 1,
                "legendFormat": "Migrating",
                "refId": "A"
              },
              {
                "datasource": {
                  "type": "prometheus",
                  "uid": "${datasource}"
                },
                "exemplar": true,
                "expr": "sum by (datacenter) (nomad_client_allocations_blocked{job=~\"$job\", datacenter=~\"$datacenter\", instance=~\"$instance\"})",
                "format": "time_series",
                "interval": "",
                "intervalFactor": 1,
                "legendFormat": "Blocked",
                "refId": "B"
              },
              {
                "datasource": {
                  "type": "prometheus",
                  "uid": "${datasource}"
                },
                "exemplar": true,
                "expr": "sum by (datacenter) (nomad_client_allocations_pending{job=~\"$job\", datacenter=~\"$datacenter\", instance=~\"$instance\"})",
                "format": "time_series",
                "interval": "",
                "intervalFactor": 1,
                "legendFormat": "Pending",
                "refId": "C"
              },
              {
                "datasource": {
                  "type": "prometheus",
                  "uid": "${datasource}"
                },
                "exemplar": true,
                "expr": "sum by (datacenter)  (nomad_client_allocations_running{job=~\"$job\", datacenter=~\"$datacenter\", instance=~\"$instance\"})",
                "format": "time_series",
                "interval": "",
                "intervalFactor": 1,
                "legendFormat": "Running",
                "refId": "D"
              },
              {
                "datasource": {
                  "type": "prometheus",
                  "uid": "${datasource}"
                },
                "exemplar": true,
                "expr": "sum by (datacenter)  (nomad_client_allocations_terminal{job=~\"$job\", datacenter=~\"$datacenter\", instance=~\"$instance\"})",
                "format": "time_series",
                "interval": "",
                "intervalFactor": 1,
                "legendFormat": "Terminal",
                "refId": "E"
              }
            ],
            "title": "Summary",
            "type": "state-timeline"
          },
          {
            "datasource": {
              "type": "prometheus",
              "uid": "grafanacloud-prom"
            },
            "gridPos": {
              "h": 1,
              "w": 24,
              "x": 0,
              "y": 6
            },
            "id": 2,
            "targets": [
              {
                "datasource": {
                  "type": "prometheus",
                  "uid": "grafanacloud-prom"
                },
                "refId": "A"
              }
            ],
            "title": "Nomad clients",
            "type": "row"
          },
          {
            "datasource": {
              "uid": "$datasource"
            },
            "fieldConfig": {
              "defaults": {
                "color": {
                  "mode": "thresholds"
                },
                "decimals": 1,
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
                "unit": "dtdurations"
              },
              "overrides": []
            },
            "gridPos": {
              "h": 5,
              "w": 4,
              "x": 0,
              "y": 7
            },
            "id": 4,
            "links": [],
            "maxDataPoints": 100,
            "options": {
              "colorMode": "none",
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
            "pluginVersion": "9.3.2",
            "repeat": "instance",
            "repeatDirection": "v",
            "targets": [
              {
                "datasource": {
                  "uid": "$datasource"
                },
                "expr": "nomad_client_uptime{job=~\"$job\", datacenter=~\"$datacenter\", instance=~\"$instance\"}",
                "format": "time_series",
                "interval": "",
                "intervalFactor": 1,
                "legendFormat": "",
                "refId": "A"
              }
            ],
            "title": "Uptime",
            "type": "stat"
          },
          {
            "datasource": {
              "uid": "$datasource"
            },
            "fieldConfig": {
              "defaults": {
                "color": {
                  "mode": "thresholds"
                },
                "mappings": [],
                "max": 100,
                "min": 0,
                "thresholds": {
                  "mode": "absolute",
                  "steps": [
                    {
                      "color": "green",
                      "value": null
                    },
                    {
                      "color": "yellow",
                      "value": 80
                    },
                    {
                      "color": "red",
                      "value": 90
                    }
                  ]
                },
                "unit": "percent"
              },
              "overrides": []
            },
            "gridPos": {
              "h": 5,
              "w": 5,
              "x": 4,
              "y": 7
            },
            "id": 7,
            "links": [],
            "maxDataPoints": 100,
            "options": {
              "orientation": "horizontal",
              "reduceOptions": {
                "calcs": [
                  "lastNotNull"
                ],
                "fields": "",
                "values": false
              },
              "showThresholdLabels": false,
              "showThresholdMarkers": true,
              "text": {}
            },
            "pluginVersion": "9.3.2",
            "repeat": "instance",
            "repeatDirection": "v",
            "targets": [
              {
                "datasource": {
                  "uid": "$datasource"
                },
                "expr": "100-sum(nomad_client_host_cpu_idle{job=~\"$job\", datacenter=~\"$datacenter\", instance=~\"$instance\"}) / count(nomad_client_host_cpu_idle{job=~\"$job\", datacenter=~\"$datacenter\", instance=~\"$instance\"})",
                "format": "time_series",
                "interval": "",
                "intervalFactor": 1,
                "legendFormat": "",
                "refId": "A"
              }
            ],
            "title": "CPU usage",
            "type": "gauge"
          },
          {
            "aliasColors": {},
            "bars": false,
            "dashLength": 10,
            "dashes": false,
            "datasource": {
              "uid": "$datasource"
            },
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
              "w": 5,
              "x": 9,
              "y": 7
            },
            "hiddenSeries": false,
            "id": 11,
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
            "pluginVersion": "9.3.2",
            "pointradius": 5,
            "points": false,
            "renderer": "flot",
            "repeat": "instance",
            "repeatDirection": "v",
            "seriesOverrides": [],
            "spaceLength": 10,
            "stack": false,
            "steppedLine": false,
            "targets": [
              {
                "datasource": {
                  "uid": "$datasource"
                },
                "expr": "nomad_client_host_memory_total{job=~\"$job\", datacenter=~\"$datacenter\", instance=~\"$instance\"}",
                "format": "time_series",
                "interval": "",
                "intervalFactor": 1,
                "legendFormat": "Total",
                "refId": "B"
              },
              {
                "datasource": {
                  "uid": "$datasource"
                },
                "expr": "nomad_client_host_memory_free{job=~\"$job\", datacenter=~\"$datacenter\", instance=~\"$instance\"}",
                "format": "time_series",
                "instant": false,
                "interval": "",
                "intervalFactor": 1,
                "legendFormat": "Free",
                "refId": "A"
              },
              {
                "datasource": {
                  "uid": "$datasource"
                },
                "expr": "nomad_client_host_memory_used{job=~\"$job\", datacenter=~\"$datacenter\", instance=~\"$instance\"}",
                "format": "time_series",
                "interval": "",
                "intervalFactor": 1,
                "legendFormat": "Used",
                "refId": "C"
              },
              {
                "datasource": {
                  "uid": "$datasource"
                },
                "expr": "nomad_client_host_memory_available{job=~\"$job\", datacenter=~\"$datacenter\", instance=~\"$instance\"}",
                "format": "time_series",
                "interval": "",
                "intervalFactor": 1,
                "legendFormat": "Available",
                "refId": "D"
              }
            ],
            "thresholds": [],
            "timeRegions": [],
            "title": "Memory",
            "tooltip": {
              "shared": true,
              "sort": 0,
              "value_type": "individual"
            },
            "type": "graph",
            "xaxis": {
              "mode": "time",
              "show": true,
              "values": []
            },
            "yaxes": [
              {
                "format": "decbytes",
                "logBase": 1,
                "show": true
              },
              {
                "format": "short",
                "logBase": 1,
                "show": true
              }
            ],
            "yaxis": {
              "align": false
            }
          },
          {
            "aliasColors": {},
            "bars": false,
            "dashLength": 10,
            "dashes": false,
            "datasource": {
              "uid": "$datasource"
            },
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
              "w": 5,
              "x": 14,
              "y": 7
            },
            "hiddenSeries": false,
            "id": 13,
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
            "pluginVersion": "9.3.2",
            "pointradius": 5,
            "points": false,
            "renderer": "flot",
            "repeat": "instance",
            "repeatDirection": "v",
            "seriesOverrides": [],
            "spaceLength": 10,
            "stack": false,
            "steppedLine": false,
            "targets": [
              {
                "datasource": {
                  "uid": "$datasource"
                },
                "expr": "max(nomad_client_host_disk_size{job=~\"$job\", datacenter=~\"$datacenter\", instance=~\"$instance\"}) by (disk)",
                "format": "time_series",
                "interval": "",
                "intervalFactor": 1,
                "legendFormat": "Total - {{disk}}",
                "refId": "B"
              },
              {
                "datasource": {
                  "uid": "$datasource"
                },
                "expr": "avg(nomad_client_host_disk_available{job=~\"$job\", datacenter=~\"$datacenter\", instance=~\"$instance\"}) by (disk)",
                "format": "time_series",
                "interval": "",
                "intervalFactor": 1,
                "legendFormat": "Available - {{disk}}",
                "refId": "A"
              }
            ],
            "thresholds": [],
            "timeRegions": [],
            "title": "Disk usage",
            "tooltip": {
              "shared": true,
              "sort": 0,
              "value_type": "individual"
            },
            "type": "graph",
            "xaxis": {
              "mode": "time",
              "show": true,
              "values": []
            },
            "yaxes": [
              {
                "decimals": 0,
                "format": "decbytes",
                "logBase": 1,
                "show": true
              },
              {
                "format": "decbytes",
                "logBase": 1,
                "show": false
              }
            ],
            "yaxis": {
              "align": false
            }
          },
          {
            "aliasColors": {},
            "bars": false,
            "dashLength": 10,
            "dashes": false,
            "datasource": {
              "uid": "$datasource"
            },
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
              "w": 5,
              "x": 19,
              "y": 7
            },
            "hiddenSeries": false,
            "id": 15,
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
            "pluginVersion": "9.3.2",
            "pointradius": 5,
            "points": false,
            "renderer": "flot",
            "repeat": "instance",
            "repeatDirection": "v",
            "seriesOverrides": [],
            "spaceLength": 10,
            "stack": false,
            "steppedLine": false,
            "targets": [
              {
                "datasource": {
                  "uid": "$datasource"
                },
                "expr": "avg(nomad_client_host_disk_inodes_percent{job=~\"$job\", datacenter=~\"$datacenter\", instance=~\"$instance\"}) by (disk)",
                "format": "time_series",
                "interval": "",
                "intervalFactor": 1,
                "legendFormat": "{{disk}}",
                "refId": "A"
              }
            ],
            "thresholds": [],
            "timeRegions": [],
            "title": "Disk inodes",
            "tooltip": {
              "shared": true,
              "sort": 0,
              "value_type": "individual"
            },
            "type": "graph",
            "xaxis": {
              "mode": "time",
              "show": true,
              "values": []
            },
            "yaxes": [
              {
                "format": "percent",
                "logBase": 1,
                "show": true
              },
              {
                "format": "short",
                "logBase": 1,
                "show": true
              }
            ],
            "yaxis": {
              "align": false
            }
          }
        ],
        "refresh": "30s",
        "schemaVersion": 37,
        "style": "dark",
        "tags": [
          "nomad-integration"
        ],
        "templating": {
          "list": [
            {
              "current": {
                "selected": false,
                "text": "grafanacloud-k3d-prom",
                "value": "grafanacloud-k3d-prom"
              },
              "hide": 0,
              "includeAll": false,
              "label": "Data Source",
              "multi": false,
              "name": "datasource",
              "options": [],
              "query": "prometheus",
              "refresh": 1,
              "regex": "(?!grafanacloud-usage|grafanacloud-ml-metrics).+",
              "skipUrlSync": false,
              "type": "datasource"
            },
            {
              "current": {
                "selected": false,
                "text": "All",
                "value": "$__all"
              },
              "datasource": {
                "type": "prometheus",
                "uid": "${datasource}"
              },
              "definition": "label_values(nomad_client_uptime, job)",
              "hide": 0,
              "includeAll": true,
              "allValue": ".+",
              "label": "job",
              "multi": true,
              "name": "job",
              "options": [],
              "query": {
                "query": "label_values(nomad_client_uptime, job)",
                "refId": "StandardVariableQuery"
              },
              "refresh": 1,
              "regex": "",
              "skipUrlSync": false,
              "sort": 0,
              "type": "query"
            },
            {
              "current": {
                "isNone": true,
                "selected": false,
                "text": "None",
                "value": ""
              },
              "datasource": {
                "type": "prometheus",
                "uid": "${datasource}"
              },
              "definition": "label_values(nomad_client_uptime, datacenter)",
              "hide": 0,
              "includeAll": false,
              "label": "DC",
              "multi": false,
              "name": "datacenter",
              "options": [],
              "query": {
                "query": "label_values(nomad_client_uptime, datacenter)",
                "refId": "StandardVariableQuery"
              },
              "refresh": 1,
              "regex": "",
              "skipUrlSync": false,
              "sort": 0,
              "tagValuesQuery": "",
              "tagsQuery": "",
              "type": "query",
              "useTags": false
            },
            {
              "current": {
                "selected": false,
                "text": "All",
                "value": "$__all"
              },
              "datasource": {
                "type": "prometheus",
                "uid": "${datasource}"
              },
              "definition": "label_values(nomad_client_uptime{datacenter=\"$datacenter\"}, instance)",
              "hide": 0,
              "includeAll": true,
              "allValue": ".+",
              "label": "instance",
              "multi": true,
              "name": "instance",
              "options": [],
              "query": {
                "query": "label_values(nomad_client_uptime{datacenter=\"$datacenter\"}, instance)",
                "refId": "prometheus-instance-Variable-Query"
              },
              "refresh": 1,
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
          "from": "now-30m",
          "to": "now"
        },
        "timepicker": {
          "refresh_intervals": [
            "5s",
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
        "timezone": "",
        "title": "Nomad cluster",
        "uid": "CiP3mZVik",
        "version": 4,
        "weekStart": ""
      },
  },
}
