package grafana

Template: {
	name: string
	current?: {
		selected?: bool
		text?: [...string]
		value?: [...string]
	}
	hide:       int | *0
	includeAll: bool | *false
	label?:     string
	multi:      bool | *false
	options: [...{selected: bool | *false, text: string, value: string}]
	query:       string
	refresh:     int | *1
	regex:       string | *""
	skipUrlSync: bool | *false
	type:        "datasource" | "query"
}

#DataSourceTemplate: Template & {
	type: "datasource"
}

#QueryTemplate: Template & {
	type:            "query"
	datasource:      string
	definition:      string
	query:           string
	sort:            int | *0
	tagValuesQuery?: string
	tags?: [...string]
	tagsQuery?: string
	useTags:    bool | *false
}
