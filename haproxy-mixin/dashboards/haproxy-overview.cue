package dashboards

import (
	"github.com/jdbaldry/haproxy-mixin/grafana"
	"github.com/jdbaldry/haproxy-mixin/grafana/panel"
)

let headline = _section & {
	_panelSize: {h: 3, w: 4}
	row: panel.#Row & {
		id: 100
		title:     "Headline"
		collapsed: false
	}
	panels: [ uptime, processCurrentConnections, processMemoryAllocated, processMemoryUsed ]
}

let frontend = _section & {
	_origin: {
		x: 0
		y: 3
	}
	_panelSize: {h: 6, w: _dashboardWidth}
	row: {
		id: 200
		title:     "Frontend"
		collapsed: false
	}
	panels: [frontendTable	]
}

let backend = _section & {
	_origin: {
		x: 0
		y: 9
	}
	_panelSize: {w: _dashboardWidth, h: 6}
	row: {
		id: 300
		title:     "Backend"
		collapsed: false
	}
	panels: [backendTable]
}

let configuration = _section & {
	_origin: {
		x: 0
		y: 15
	}
	_panelSize: {h: 2, w: 3}
	row: {
		id: 400
		title:     "Configuration"
		collapsed: false
	}

	panels: [ processCount, processThreads, processConnectionsLimit, processMemoryLimit, processFDLimit, processSocketLimit ]
}

{
	dashboards: "haproxy-overview.json": {
		title: "HAProxy / Overview"
		uid:   "HAProxyOverview"
		panels:
			[headline.row] +
			[ for i, panel in headline.panels {
				panel & {
					id: headline.row.id + (i+1)
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
					id: frontend.row.id + (i+1)
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
					id: backend.row.id + (i+1)
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
					id: configuration.row.id + (i+1)
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
