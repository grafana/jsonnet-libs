package dashboards

import (
	"github.com/jdbaldry/haproxy-mixin/grafana"
	"github.com/jdbaldry/haproxy-mixin/grafana/panel"
)

let headline = _board & {
	_panelSize: {h: 3, w: 4}
	row: panel.#Row & {
		title:     "Headline"
		collapsed: false
	}
	panels: [
		_statPanel & {
			title:       "Uptime"
			description: "Server uptime"
			fieldConfig: defaults: {
				unit: "s"
				thresholds: {
					mode: "absolute"
					steps: [{color: "blue", value: null}]
				}
			}
			targets: [{
				expr:  "time() - haproxy_process_start_time_seconds" + "{\(_baseMatchers)}"
				refId: "A"
			}]
		},
		_statPanel & {
			title:       "Current connections"
			description: "Number of active sessions"
			fieldConfig: defaults: {
				thresholds: {
					mode: "absolute"
					steps: [{color: "blue", value: null}]
				}
			}
			targets: [{
				expr:  "haproxy_process_current_connections" + "{\(_baseMatchers)}"
				refId: "A"
			}]
		},
		_statPanel & {
			title:       "Memory allocated"
			description: "Total amount of memory allocated in pools"
			fieldConfig: defaults: {
				unit: "bytes"
				thresholds: {
					mode: "absolute"
					steps: [{color: "blue", value: null}]
				}
			}
			targets: [{
				expr:  "haproxy_process_pool_allocated_bytes" + "{\(_baseMatchers)}"
				refId: "A"
			}]
		},
		_statPanel & {
			title:       "Memory used"
			description: "Total amount of memory used in pools"
			fieldConfig: defaults: {
				unit: "bytes"
				thresholds: {
					mode: "absolute"
					steps: [{color: "blue", value: null}]
				}
			}
			targets: [{
				expr:  "haproxy_process_pool_used_bytes" + "{\(_baseMatchers)}"
				refId: "A"
			}]
		},
	]
}

let frontend = _board & {
	_origin: {
		x: 0
		y: 3
	}
	_panelSize: {h: 6, w: _dashboardWidth}
	row: {
		title:     "Frontend"
		collapsed: false
	}
	panels: [
		panel.#Table & {
			datasource: "prometheus"
			fieldConfig: defaults: {
				custom: {displayMode: "color-background"}
				thresholds: {
					mode: "absolute"
					steps: [
						{color: "rgba(0,0,0,0)", value: null},
						{color: "red", value:           0},
						{color: "green", value:         1},
					]
				}
				links: [{
					title: "Frontend"
					url:   "/d/HAProxyFrontend/haproxy-frontend?${__all_variables}&var-frontend=${__data.fields.Frontend}"
				}]
				mappings: [
					{id: 1, type: 1, text: "Down", value: "0"},
					{id: 2, type: 1, text: "Up", value:   "1"},
				]
			}
			options: sortBy: [{displayName: "Status", desc: false}]
			targets: [{
				expr:    "haproxy_frontend_status" + "{\(_baseMatchers)}"
				refId:   "A"
				format:  "table"
				instant: true
			}]
			transformations: [
				{
					id: "organize"
					options: {
						excludeByName: {
							Time:       true
							"__name__": true
						}
						renameByName: {
							instance: "Instance"
							job:      "Job"
							proxy:    "Frontend"
							Value:    "Status"
						}
					}
				},
			]
		},
	]
}

let backend = _board & {
	_origin: {
		x: 0
		y: 9
	}
	_panelSize: {w: _dashboardWidth, h: 6}
	row: {
		title:     "Backend"
		collapsed: false
	}
	panels: [
		panel.#Table & {
			datasource: "prometheus"
			fieldConfig: defaults: {
				custom: {displayMode: "color-background"}
				thresholds: {
					mode: "absolute"
					steps: [
						{color: "rgba(0,0,0,0)", value: null},
						{color: "red", value:           0},
						{color: "green", value:         1},
					]
				}
				links: [{
					title: "Backend"
					url:   "/d/HAProxyBackend/haproxy-backend?${__all_variables}&var-backend=${__data.fields.Backend}"
				}]
				mappings: [
					{id: 1, type: 1, text: "Down", value: "0"},
					{id: 2, type: 1, text: "Up", value:   "1"},
				]
			}
			targets: [{
				expr:    "haproxy_backend_status" + "{\(_baseMatchers)}"
				refId:   "A"
				format:  "table"
				instant: true
			}]
			transformations: [
				{
					id: "organize"
					options: {
						excludeByName: {
							Time:       true
							"__name__": true
						}
						renameByName: {
							instance: "Instance"
							job:      "Job"
							proxy:    "Backend"
							Value:    "Status"
						}
					}
				},
			]
		},
	]
}

let configuration = _board & {
	_origin: {
		x: 0
		y: 15
	}
	_panelSize: {h: 2, w: 3}
	row: {
		title:     "Configuration"
		collapsed: false
	}

	panels: [
		_statPanel & {
			title:       "Threads"
			description: "Configured number of threads"
			fieldConfig: defaults: {
				thresholds: {
					mode: "absolute"
					steps: [{color: "blue"}]
				}
			}
			targets: [{
				expr:  "haproxy_process_nbthread" + "{\(_baseMatchers)}"
				refId: "A"
			}]
		},
		_statPanel & {
			title:       "Processes"
			description: "Configured number of processes"
			fieldConfig: defaults: {
				thresholds: {
					mode: "absolute"
					steps: [{color: "blue"}]
				}
			}
			targets: [{
				expr:  "haproxy_process_nbproc" + "{\(_baseMatchers)}"
				refId: "A"
			}]
		},
		_statPanel & {
			title:       "Connections limit"
			description: "Configured maximum number of concurrent connections"
			fieldConfig: defaults: {
				thresholds: {
					mode: "absolute"
					steps: [{color: "blue"}]
				}
			}
			targets: [{
				expr:  "haproxy_process_max_connections" + "{\(_baseMatchers)}"
				refId: "A"
			}]
		},
		_statPanel & {
			title:       "Memory limit"
			description: "Per-process memory limit"
			fieldConfig: defaults: {
				unit: "bytes"
				mappings: [{id: 1, type: 1, text: "unset", value: "0"}]
				thresholds: {
					mode: "absolute"
					steps: [{color: "blue"}]
				}
			}
			targets: [{
				expr:  "haproxy_process_max_memory_bytes" + "{\(_baseMatchers)}"
				refId: "A"
			}]
		},
		_statPanel & {
			title:       "File descriptors limit"
			description: "Maximum number of open file descriptors"
			fieldConfig: defaults: {
				mappings: [{id: 1, type: 1, text: "unset", value: "0"}]
				thresholds: {
					mode: "absolute"
					steps: [{color: "blue"}]
				}
			}
			targets: [{
				expr:  "haproxy_process_max_fds" + "{\(_baseMatchers)}"
				refId: "A"
			}]
		},
		_statPanel & {
			title:       "Socket limit"
			description: "Maximum number of open sockets"
			fieldConfig: defaults: {
				thresholds: {
					mode: "absolute"
					steps: [{color: "blue"}]
				}
			}
			targets: [{
				expr:  "haproxy_process_max_sockets"
				refId: "A"
			}]
		},

	]
}

{
	dashboards: "haproxy-overview.json": {
		title: "HAProxy / Overview"
		uid:   "HAProxyOverview"
		panels:
			[headline.row] +
			[ for i, panel in headline.panels {
				panel & {
					gridPos: {
						x: headline._origin.x + i*headline._panelSize.w
						y: headline._origin.y + (i * headline._panelSize.w div _dashboardWidth * headline._panelSize.h)
						w: headline._panelSize.w
						h: headline._panelSize.h
					}
				}
			},
			] +
			[frontend.row] +
			[ for i, panel in frontend.panels {
				panel & {
					gridPos: {
						x: frontend._origin.x + i*frontend._panelSize.w
						y: frontend._origin.y + (i * frontend._panelSize.w div _dashboardWidth * frontend._panelSize.h)
						w: frontend._panelSize.w
						h: frontend._panelSize.h
					}
				}
			},
			] +
			[backend.row] +
			[ for i, panel in backend.panels {
				panel & {
					gridPos: {
						x: backend._origin.x + i*backend._panelSize.w
						y: backend._origin.y + (i * backend._panelSize.w div _dashboardWidth * backend._panelSize.h) + 1
						w: backend._panelSize.w
						h: backend._panelSize.h
					}
				}
			},
			] +
			[configuration.row] +
			[ for i, panel in configuration.panels {
				panel & {
					gridPos: {
						x: configuration._origin.x + i*configuration._panelSize.w
						y: configuration._origin.y + (i * headline._panelSize.w div _dashboardWidth * headline._panelSize.h)
						w: configuration._panelSize.w
						h: configuration._panelSize.h
					}
				}
			},
			]
		templating: {
			list: [
				grafana.Template & {
					name:  "datasource"
					query: "prometheus"
					type:  "datasource"
				},
				grafana.#QueryTemplate & {
					name:       "instance"
					datasource: "prometheus"
					definition: "label_values(haproxy_process_start_time_seconds, instance)"
					includeAll: true
					multi:      true
					query:      "label_values(haproxy_process_start_time_seconds, instance)"
				},
				grafana.#QueryTemplate & {
					name:       "job"
					datasource: "prometheus"
					definition: "label_values(haproxy_process_start_time_seconds, job)"
					includeAll: true
					multi:      true
					query:      "label_values(haproxy_process_start_time_seconds, job)"
				},

			]
		}
	}
}
