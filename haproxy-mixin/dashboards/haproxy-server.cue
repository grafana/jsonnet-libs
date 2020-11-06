package dashboards

import (
	"github.com/jdbaldry/haproxy-mixin/grafana"
	"github.com/jdbaldry/haproxy-mixin/grafana/panel"
)

serverHTTPResponsesPerSecond: panel.#Graph & {
	title:       "HTTP"
	description: "HTTP responses per second. There will be no data for servers using tcp mode."
	fieldConfig: defaults: unit: "reqps"
	targets: [{
		expr:  "rate(haproxy_server_http_responses_total{\(_serverMatchers)}[$__rate_interval])"
		refId: "A"
	}]
	yaxes: [{min: 0}, {min: 0}]
}

serverMaxDuration: panel.#Graph & {
	title:       "Max duration"
	description: "Max duration for last 1024 succesful connections"
	fieldConfig: defaults: unit: "s"
	targets: [
		{
			expr:  "haproxy_server_max_queue_time_seconds{\(_serverMatchers)}"
			refId: "A"
		},
		{
			expr:  "haproxy_server_max_connect_time_seconds{\(_serverMatchers)}"
			refId: "B"
		},
		{
			expr:  "haproxy_server_max_response_time_seconds{\(_serverMatchers)}"
			refId: "C"
		},
		{
			expr:  "haproxy_server_max_total_time_seconds{\(_serverMatchers)}"
			refId: "D"
		},
	]
	yaxes: [{min: 0}, {min: 0}]
}

serverAverageDuration: panel.#Graph & {
	title:       "Average duration"
	description: "Average duration for last 1024 succesful connections"
	fieldConfig: defaults: unit: "s"
	targets: [
		{
			expr:  "haproxy_server_queue_time_average_seconds{\(_serverMatchers)}"
			refId: "A"
		},
		{
			expr:  "haproxy_server_connect_time_average_seconds{\(_serverMatchers)}"
			refId: "B"
		},
		{
			expr:  "haproxy_server_response_time_average_seconds{\(_serverMatchers)}"
			refId: "C"
		},
		{
			expr:  "haproxy_server_total_time_average_seconds{\(_serverMatchers)}"
			refId: "D"
		},
	]
	yaxes: [{min: 0}, {min: 0}]
}

serverConnectionsPerSecond: panel.#Graph & {
	title:       "Attempted connections"
	description: "Attempted connections per second"
	fieldConfig: defaults: unit: "connps"
	targets: [{
		expr:  "rate(haproxy_server_connection_attempts_total{\(_serverMatchers)}[$__rate_interval])"
		refId: "A"
	}]
	yaxes: [{min: 0}, {min: 0}]
}

serverResponseErrors: panel.#Graph & {
	title:       "Response"
	datasource:  "prometheus"
	description: "Response errors per second"
	targets: [{
		expr:  "rate(haproxy_server_response_errors_total{\(_serverMatchers)}[$__rate_interval])"
		refId: "A"
	}]
}

serverConnectionErrors: panel.#Graph & {
	title:       "Connection"
	datasource:  "prometheus"
	description: "Connection errors per second"
	targets: [{
		expr:  "rate(haproxy_server_connection_errors_total{\(_serverMatchers)}[$__rate_interval])"
		refId: "A"
	}]
	stack: true
	yaxes: [{min: 0}, {min: 0}]
}

serverInternalErrors: panel.#Graph & {
	title:       "Internal"
	datasource:  "prometheus"
	description: "Internal errors per second"
	targets: [{
		expr:  "rate(haproxy_server_internal_errors_total{\(_serverMatchers)}[$__rate_interval])"
		refId: "A"
	}]
	stack: true
	yaxes: [{min: 0}, {min: 0}]
}

serverBytes: panel.#Graph & {
	title: "Bytes in/out"
	fieldConfig: defaults: unit: "bytes"
	targets: [
		{
			expr:         "rate(haproxy_server_bytes_in_total{\(_serverMatchers)}[$__rate_interval])"
			refId:        "A"
			legendFormat: "in{\(_serverMatchers)}"
		},
		{
			expr:         "rate(haproxy_server_bytes_out_total{\(_serverMatchers)}[$__rate_interval])"
			refId:        "B"
			legendFormat: "out{\(_serverMatchers)}"
		},
	]
	seriesOverrides: [{alias: "/.*out.*/", transform: "negative-Y"}]
}

let serverRequests = _board & {
	_panelSize: {h: 6, w: 8}
	row: panel.#Row & {
		title:     "Requests"
		collapsed: false
	}
	panels: [ for panel in [serverHTTPResponsesPerSecond, serverConnectionsPerSecond, serverBytes] {panel & {datasource: "prometheus"}}]
}

let serverErrors = _board & {
	_origin: y: 6
	_panelSize: {h: 6, w: 8}
	row: panel.#Row & {
		title:     "Errors"
		collapsed: false
	}
	panels: [ for panel in [serverResponseErrors, serverConnectionErrors, serverInternalErrors] {panel & {datasource: "prometheus"}}]
}

let serverDuration = _board & {
	_origin: y: 12
	_panelSize: {h: 6, w: 8}
	row: panel.#Row & {
		title:     "Duration"
		collapsed: false
	}
	panels: [ for panel in [serverAverageDuration, serverMaxDuration] {panel & {datasource: "prometheus"}}]
}

{
	dashboards: "haproxy-server.json": {
		title: "HAProxy / Server"
		uid:   "HAProxyServer"
		panels:
			[serverRequests.row] +
			[ for i, panel in serverRequests.panels {
				panel & {
					gridPos: {
						x: serverRequests._origin.x + i*serverRequests._panelSize.w
						y: serverRequests._origin.y + (i * serverRequests._panelSize.w div _dashboardWidth * serverRequests._panelSize.h)
						w: serverRequests._panelSize.w
						h: serverRequests._panelSize.h
					}
				}
			},
			] +
			[serverErrors.row] +
			[ for i, panel in serverErrors.panels {
				panel & {
					gridPos: {
						x: serverErrors._origin.x + i*serverErrors._panelSize.w
						y: serverErrors._origin.y + (i * serverErrors._panelSize.w div _dashboardWidth * serverErrors._panelSize.h)
						w: serverErrors._panelSize.w
						h: serverErrors._panelSize.h
					}
				}
			},
			] +
			[serverDuration.row] +
			[ for i, panel in serverDuration.panels {
				panel & {
					gridPos: {
						x: serverDuration._origin.x + i*serverDuration._panelSize.w
						y: serverDuration._origin.y + (i * serverDuration._panelSize.w div _dashboardWidth * serverDuration._panelSize.h)
						w: serverDuration._panelSize.w
						h: serverDuration._panelSize.h
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
				grafana.#QueryTemplate & {
					name:       "server"
					datasource: "prometheus"
					definition: "label_values(haproxy_server_status, server)"
					includeAll: true
					multi:      true
					query:      "label_values(haproxy_server_status, server)"
				},
			]
		}
	}
}
