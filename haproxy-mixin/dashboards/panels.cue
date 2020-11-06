// Mostly dashboard independent panels.
package dashboards

import "github.com/jdbaldry/haproxy-mixin/grafana/panel"

// Common configuration for all panels.
_statPanel:  panel.#Stat & {datasource:  _datasource}
_tablePanel: panel.#Table & {datasource: _datasource}
_graphPanel: panel.#Graph & {datasource: _datasource}

uptime: _statPanel & {
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
}

processCurrentConnections: _statPanel & {
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
}

processMemoryAllocated: _statPanel & {
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
}

processMemoryUsed: _statPanel & {
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
}

serverHTTPResponsesPerSecond: _graphPanel & {
	title:       "HTTP"
	description: "HTTP responses per second. There will be no data for servers using tcp mode."
	fieldConfig: defaults: unit: "reqps"
	targets: [{
		expr:  "rate(haproxy_server_http_responses_total{\(_serverMatchers)}[$__rate_interval])"
		refId: "A"
	}]
	yaxes: [{min: 0}, {min: 0}]
}

serverMaxDuration: _graphPanel & {
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

serverAverageDuration: _graphPanel & {
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

serverConnectionsPerSecond: _graphPanel & {
	title:       "Attempted connections"
	description: "Attempted connections per second"
	fieldConfig: defaults: unit: "connps"
	targets: [{
		expr:  "rate(haproxy_server_connection_attempts_total{\(_serverMatchers)}[$__rate_interval])"
		refId: "A"
	}]
	yaxes: [{min: 0}, {min: 0}]
}

serverResponseErrors: _graphPanel & {
	title:       "Response"
	datasource:  "prometheus"
	description: "Response errors per second"
	targets: [{
		expr:  "rate(haproxy_server_response_errors_total{\(_serverMatchers)}[$__rate_interval])"
		refId: "A"
	}]
}

serverConnectionErrors: _graphPanel & {
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

serverInternalErrors: _graphPanel & {
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

serverBytes: _graphPanel & {
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

// I didn't find this panel to be of use in my specific dashboard where no cache lookups were made but it's left here as an example.
cacheSuccess: _graphPanel & {
	title:       "Cache success"
	description: "Percentage of HTTP cache hits."
	fieldConfig: defaults: unit: "reqps"
	targets: [{
		expr:  """
					rate(haproxy_frontend_http_cache_lookups_total{\(_frontendMatchers)}[5m])
					/
					rate(haproxy_frontend_http_cache_hits_total{\(_frontendMatchers)}[5m])
				"""
		refId: "A"
	}]
	yaxes: [{min: 0}, {min: 0}]
}

requestErrors: _graphPanel & {
	title:       "Requests"
	datasource:  "prometheus"
	description: "Request errors per second"
	targets: [ {
		expr:  "rate(haproxy_frontend_request_errors_total{\(_frontendMatchers)}[$__rate_interval])"
		refId: "a"
	},
	]
	stack: true
	yaxes: [{min: 0}, {min: 0}]
}

httpRequestsPerSecond: _graphPanel & {
	title:       "HTTP"
	description: "HTTP requests per second"
	fieldConfig: defaults: unit: "reqps"
	targets: [{
		expr:  "rate(haproxy_frontend_http_requests_total{\(_frontendMatchers)}[$__rate_interval])"
		refId: "A"
	}]
	yaxes: [{min: 0}, {min: 0}]
}

connectionsPerSecond: _graphPanel & {
	title:       "Connections"
	description: "Connections per second"
	fieldConfig: defaults: unit: "connps"
	targets: [{
		expr:  "rate(haproxy_frontend_connections_total{\(_frontendMatchers)}[$__rate_interval])"
		refId: "A"
	}]
	yaxes: [{min: 0}, {min: 0}]
}

internalErrors: _graphPanel & {
	title:       "Internal"
	datasource:  "prometheus"
	description: "Internal errors per second"
	targets: [{
		expr:  "rate(haproxy_frontend_internal_errors_total{\(_frontendMatchers)}[$__rate_interval])"
		refId: "A"
	}]
	stack: true
	yaxes: [{min: 0}, {min: 0}]
}

frontendBytes: _graphPanel & {
	title: "Bytes in/out"
	fieldConfig: defaults: unit: "bytes"
	targets: [
		{
			expr:         "rate(haproxy_frontend_bytes_in_total{\(_frontendMatchers)}[$__rate_interval])"
			refId:        "A"
			legendFormat: "in{\(_frontendMatchers)}"
		},
		{
			expr:         "rate(haproxy_frontend_bytes_out_total{\(_frontendMatchers)}[$__rate_interval])"
			refId:        "B"
			legendFormat: "out{\(_frontendMatchers)}"
		},
	]
	seriesOverrides: [{alias: "/.*out.*/", transform: "negative-Y"}]
}

backendHTTPRequestsPerSecond: _graphPanel & {
	title:       "HTTP"
	description: "HTTP requests per second. There will be no data for backends using tcp mode."
	fieldConfig: defaults: unit: "reqps"
	targets: [{
		expr:  "rate(haproxy_backend_http_requests_total{\(_backendMatchers)}[$__rate_interval])"
		refId: "A"
	}]
	yaxes: [{min: 0}, {min: 0}]
}

backendMaxDuration: _graphPanel & {
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

backendAverageDuration: _graphPanel & {
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

backendConnectionsPerSecond: _graphPanel & {
	title:       "Attempted connections"
	description: "Attempted connections per second"
	fieldConfig: defaults: unit: "connps"
	targets: [{
		expr:  "rate(haproxy_backend_connection_attempts_total{\(_backendMatchers)}[$__rate_interval])"
		refId: "A"
	}]
	yaxes: [{min: 0}, {min: 0}]
}

backendResponseErrors: _graphPanel & {
	title:       "Response"
	datasource:  "prometheus"
	description: "Response errors per second"
	targets: [{
		expr:  "rate(haproxy_backend_response_errors_total{\(_backendMatchers)}[$__rate_interval])"
		refId: "A"
	}]
}

backendConnectionErrors: _graphPanel & {
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

backendInternalErrors: _graphPanel & {
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

backendBytes: _graphPanel & {
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

serverTable: _tablePanel & {
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
}

frontendTable: _tablePanel & {
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
}

backendTable: _tablePanel & {
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
}

processThreads: _statPanel & {
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
}

processCount: _statPanel & {
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
}

processConnectionsLimit: _statPanel & {
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
}

processMemoryLimit: _statPanel & {
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
}

processFDLimit: _statPanel & {
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
}

processSocketLimit: _statPanel & {
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
}
