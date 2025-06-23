package signal

// Signal source configuration - defines how to query and transform a signal
// Each signal can have multiple sources (prometheus, opentelemetry, etc.)
#signalSource: close({
	// Base PromQL/LogQL expression in simplest form
	// Supports templating variables like %(queriesSelector)s, %(groupLabels)s
	// Automatically transformed based on signal type (counter, histogram, etc.)
	// Example: "node_cpu_seconds_total{%(queriesSelector)s}"
	expr: string
	
	// Additional wrapper functions applied AFTER auto-transformations
	// Array of [left_part, right_part] pairs that wrap the expression
	// Example: [["topk(10,", ")"]] wraps expression as topk(10, <expression>)
	exprWrappers?: [[string, string]]
	
	// Rate function to use for counter signal types
	// Applied as: <rangeFunction>(<expr>[<interval>])
	// - "rate": average rate of increase per second
	// - "irate": instantaneous rate based on last two data points  
	// - "delta": difference between first and last value
	// - "idelta": instantaneous delta based on last two data points
	// - "increase": total increase over time range
	rangeFunction?: "rate" | "irate" | "delta" | "idelta" | "increase"
	
	// Override aggregation function for this specific source
	// Takes precedence over signal and signal group defaults
	aggFunction?: #aggFunction
	
	// Extra labels to keep when aggregating with by() clause
	// Used in conjunction with aggLevel to control aggregation scope
	// Example: ["pool", "level"] keeps these labels during aggregation
	aggKeepLabels?: [...string]
	
	// Label name used to extract info from "info" type signals
	// Only applicable when signal type is "info"
	// Example: "version" extracts version info from info metric
	infoLabel?: string
	
	// Custom legend template to override automatic legend generation
	// Supports Grafana templating like {{instance}}, {{job}}
	// Takes precedence over signal and signal group legend templates
	legendCustomTemplate?: string
	
	// Grafana value mappings for transforming raw values to display text/colors
	// Follows Grafana dashboard schema format for value mappings
	// Example: map 0="Down"/red, 1="Up"/green for status signals
	valueMappings?: [...{
		Type: string
		Options: {[string]: {
			Text:  string // Display text for the value
			Color: string // Color name or hex code
			Index: int    // Sort order in legend
		}}
	}]
	
	// Quantile value for histogram signal types (0.0 to 1.0)
	// Used in histogram_quantile() function for histogram transformations
	// Example: 0.95 for 95th percentile, 0.99 for 99th percentile
	quantile?: number & >=0 & <=1
})