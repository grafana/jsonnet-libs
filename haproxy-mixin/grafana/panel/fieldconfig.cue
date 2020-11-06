package panel

#FieldConfig: {
	defaults:  #Defaults
	overrides: [...#Override] | *[]
}

#Defaults: {
	custom: {
		displayMode?: string
	}
	displayName?: string
	links?:       {
		title: "Data Links"
		items: [...#Link]
	} | [...#Link]
	mappings:   [...#Mapping] | *[]
	max?:       int
	min?:       int
	noValue?:   string
	thresholds: #Threshold
	unit?:      string
}

#Step: {
	color: string
	value: int | *null
}

#Mapping: {
	id:    int
	type:  int
	from?: string
	to?:   string
	text:  string
	value: string
}

#Override: {
	matcher: {
		id:      string
		options: string
	}
	properties: [...{
		id:    string
		value: _ // [...{}] | {} | string
	}]
}

{
	id: "mappings"
	value: [
		{id: 1, type: 1, text: "Down", value: "0"},
		{id: 2, type: 1, text: "Up", value:   "1"},
	]
}
