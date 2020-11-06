package dashboards

import (
	"github.com/jdbaldry/haproxy-mixin/grafana"
	"github.com/jdbaldry/haproxy-mixin/grafana/panel"
)

backendHTTPRequestsPerSecond: panel.#Graph & {
	title:       "HTTP"
	description: "HTTP requests per second. There will be no data for backends using tcp mode."
	fieldConfig: defaults: unit: "reqps"
	targets: [{
		expr:  "rate(haproxy_backend_http_requests_total{\(_backendMatchers)}[$__rate_interval])"
		refId: "A"
	}]
	yaxes: [{min: 0}, {min: 0}]
}

backendMaxDuration: panel.#Graph & {
	title:       "Max duration"
	description: "Max duration for last 1024 succesful connections"
	fieldConfig: defaults: unit: "s"
	targets: [
		{
			expr:  "haproxy_backend_max_queue_time_seconds{\(_backendMatchers)}"
			refId: "A"
		},
		{
			expr:  "haproxy_backend_max_connect_time_seconds{\(_backendMatchers)}"
			refId: "B"
		},
		{
			expr:  "haproxy_backend_max_response_time_seconds{\(_backendMatchers)}"
			refId: "C"
		},
		{
			expr:  "haproxy_backend_max_total_time_seconds{\(_backendMatchers)}"
			refId: "D"
		},
	]
	yaxes: [{min: 0}, {min: 0}]
}

backendAverageDuration: panel.#Graph & {
	title:       "Average duration"
	description: "Average duration for last 1024 succesful connections"
	fieldConfig: defaults: unit: "s"
	targets: [
		{
			expr:  "haproxy_backend_queue_time_average_seconds{\(_backendMatchers)}"
			refId: "A"
		},
		{
			expr:  "haproxy_backend_connect_time_average_seconds{\(_backendMatchers)}"
			refId: "B"
		},
		{
			expr:  "haproxy_backend_response_time_average_seconds{\(_backendMatchers)}"
			refId: "C"
		},
		{
			expr:  "haproxy_backend_total_time_average_seconds{\(_backendMatchers)}"
			refId: "D"
		},
	]
	yaxes: [{min: 0}, {min: 0}]
}

backendConnectionsPerSecond: panel.#Graph & {
	title:       "Attempted connections"
	description: "Attempted connections per second"
	fieldConfig: defaults: unit: "connps"
	targets: [{
		expr:  "rate(haproxy_backend_connection_attempts_total{\(_backendMatchers)}[$__rate_interval])"
		refId: "A"
	}]
	yaxes: [{min: 0}, {min: 0}]
}

backendResponseErrors: panel.#Graph & {
	title:       "Response"
	datasource:  "prometheus"
	description: "Response errors per second"
	targets: [{
		expr:  "rate(haproxy_backend_response_errors_total{\(_backendMatchers)}[$__rate_interval])"
		refId: "A"
	}]
}

backendConnectionErrors: panel.#Graph & {
	title:       "Connection"
	datasource:  "prometheus"
	description: "Connection errors per second"
	targets: [{
		expr:  "rate(haproxy_backend_connection_errors_total{\(_backendMatchers)}[$__rate_interval])"
		refId: "A"
	}]
	stack: true
	yaxes: [{min: 0}, {min: 0}]
}

backendInternalErrors: panel.#Graph & {
	title:       "Internal"
	datasource:  "prometheus"
	description: "Internal errors per second"
	targets: [{
		expr:  "rate(haproxy_backend_internal_errors_total{\(_backendMatchers)}[$__rate_interval])"
		refId: "A"
	}]
	stack: true
	yaxes: [{min: 0}, {min: 0}]
}

backendBytes: panel.#Graph & {
	title: "Bytes in/out"
	fieldConfig: defaults: unit: "bytes"
	targets: [
		{
			expr:         "rate(haproxy_backend_bytes_in_total{\(_backendMatchers)}[$__rate_interval])"
			refId:        "A"
			legendFormat: "in{\(_backendMatchers)}"
		},
		{
			expr:         "rate(haproxy_backend_bytes_out_total{\(_backendMatchers)}[$__rate_interval])"
			refId:        "B"
			legendFormat: "out{\(_backendMatchers)}"
		},
	]
	seriesOverrides: [{alias: "/.*out.*/", transform: "negative-Y"}]
}

let servers = _board & {
	_origin: {
		x: 0
		y: 0
	}
	_panelSize: {w: _dashboardWidth, h: 6}
	row: {
		title:     "Servers"
		collapsed: false
	}
	panels: [
		panel.#Table & {
			datasource: "prometheus"
			fieldConfig: {
				defaults: {
					links: [{
						title: "Server"
						url:   "/d/HAProxyServer/haproxy-server?${__all_variables}&var-server=${__data.fields.Server}"
					}]
				}
				overrides: [{
					matcher: {id: "byName", options: "Status"}
					properties: [
						{
							id: "mappings"
							value: [
								{id: 1, type: 1, text: "Down", value: "0"},
								{id: 2, type: 1, text: "Up", value:   "1"},
							]
						},
						{
							id:    "custom.displayMode"
							value: "color-background"
						},
						{
							id: "thresholds"
							value: {
								mode: "absolute"
								steps: [
									{color: "rgba(0,0,0,0)", value: null},
									{color: "red", value:           0},
									{color: "green", value:         1},
								]
							}
						}]}]}
			options: sortBy: [{displayName: "Status", desc: false}]
			targets: [{
				expr:    "haproxy_server_status{\(_backendMatchers)}"
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
							server:   "Server"
							Value:    "Status"
						}
					}
				},
			]
		},
	]
}

let backendRequests = _board & {
	_panelSize: {h: 6, w: 8}
	_origin: y: 6
	row: panel.#Row & {
		title:     "Requests"
		collapsed: false
	}
	panels: [ for panel in [backendHTTPRequestsPerSecond, backendConnectionsPerSecond, backendBytes] {panel & {datasource: "prometheus"}}]
}

let backendErrors = _board & {
	_origin: y: 12
	_panelSize: {h: 6, w: 8}
	row: panel.#Row & {
		title:     "Errors"
		collapsed: false
	}
	panels: [ for panel in [backendConnectionErrors, backendInternalErrors] {panel & {datasource: "prometheus"}}]
}

let backendDuration = _board & {
	_origin: y: 12
	_panelSize: {h: 6, w: 8}
	row: panel.#Row & {
		title:     "Duration"
		collapsed: false
	}
	panels: [ for panel in [backendAverageDuration, backendMaxDuration] {panel & {datasource: "prometheus"}}]
}

{
	dashboards: "haproxy-backend.json": {
		title: "HAProxy / Backend"
		uid:   "HAProxyBackend"
		panels:
			[servers.row] +
			[ for i, panel in servers.panels {
				panel & {
					gridPos: {
						x: servers._origin.x + i*servers._panelSize.w
						y: servers._origin.y + (i * servers._panelSize.w div _dashboardWidth * servers._panelSize.h)
						w: servers._panelSize.w
						h: servers._panelSize.h
					}
				}
			},
			] +
			[backendRequests.row] +
			[ for i, panel in backendRequests.panels {
				panel & {
					gridPos: {
						x: backendRequests._origin.x + i*backendRequests._panelSize.w
						y: backendRequests._origin.y + (i * backendRequests._panelSize.w div _dashboardWidth * backendRequests._panelSize.h)
						w: backendRequests._panelSize.w
						h: backendRequests._panelSize.h
					}
				}
			},
			] +
			[backendErrors.row] +
			[ for i, panel in backendErrors.panels {
				panel & {
					gridPos: {
						x: backendErrors._origin.x + i*backendErrors._panelSize.w
						y: backendErrors._origin.y + (i * backendErrors._panelSize.w div _dashboardWidth * backendErrors._panelSize.h)
						w: backendErrors._panelSize.w
						h: backendErrors._panelSize.h
					}
				}
			},
			] +
			[backendDuration.row] +
			[ for i, panel in backendDuration.panels {
				panel & {
					gridPos: {
						x: backendDuration._origin.x + i*backendDuration._panelSize.w
						y: backendDuration._origin.y + (i * backendDuration._panelSize.w div _dashboardWidth * backendDuration._panelSize.h)
						w: backendDuration._panelSize.w
						h: backendDuration._panelSize.h
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
				grafana.#QueryTemplate & {
					name:       "backend"
					datasource: "prometheus"
					definition: "label_values(haproxy_backend_status, proxy)"
					includeAll: true
					multi:      true
					query:      "label_values(haproxy_backend_status, proxy)"
				},
			]
		}
	}
}
