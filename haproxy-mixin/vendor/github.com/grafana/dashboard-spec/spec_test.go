package main

import (
	"reflect"
	"sort"
	"testing"
)

var schemas = map[string]*Schema{
	"topLevelString": {
		Type: "string",
	},
	"topLevelStringWithTitle": {
		Title: "Human Friendly Title",
		Type:  "string",
	},
	"topLevelReadOnlyString": {
		ReadOnly: true,
		Type:     "string",
	},
	"topLevelReadOnlyStringWithDefault": {
		ReadOnly: true,
		Type:     "string",
		Default:  "default",
	},
	"topLevelArrayWithStringItems": {
		Type: "array",
		Items: &Schema{
			Type: "string",
		},
	},
	"topLevelArrayWithObjectItems": {
		Type: "array",
		Items: &Schema{
			Type: "object",
		},
	},
	"topLevelObject": {
		Type: "object",
		Properties: map[string]*Schema{
			"nestedReadOnlyStringWithDefault": {
				ReadOnly: true,
				Type:     "string",
				Default:  "default",
			},
			"nestedString": {
				Type: "string",
			},
			"nestedInteger": {
				Type: "integer",
			},
			"nestedObject": {
				Type: "object",
				Properties: map[string]*Schema{
					"deeplyNestedString": {
						Type: "string",
					},
				},
			},
			"nestedArrayWithStringItems": {
				Type: "array",
				Items: &Schema{
					Type: "string",
				},
			},
			"nestedArrayWithObjectItems": {
				Type: "array",
				Items: &Schema{
					Type: "object",
				},
			},
		},
	},
}

func TestHumanName(t *testing.T) {
	tests := map[string]struct {
		name   string
		schema Schema
		want   string
	}{
		"no title": {
			"topLevelString",
			*schemas["topLevelString"],
			"topLevelString",
		},
		"has title": {
			"topLevelStringWithTitle",
			*schemas["topLevelStringWithTitle"],
			"Human Friendly Title",
		},
	}
	for testName, test := range tests {
		if test.want != test.schema.HumanName(test.name) {
			t.Errorf("Failed on test, %q. Wanted: %q, got: %q.", testName, test.want, test.schema.HumanName(test.name))
		}
	}
}

func TestTopLevelSimpleProperties(t *testing.T) {
	want := []string{
		"topLevelArrayWithStringItems",
		"topLevelString",
		"topLevelStringWithTitle",
	}
	schema := Schema{
		Properties: schemas,
	}
	props := schema.TopLevelSimpleProperties()
	var keys []string
	for k := range props {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	if !reflect.DeepEqual(want, keys) {
		t.Errorf("Wanted: %v, got: %v.", want, keys)
	}
}

func TestReadOnlyWithDefaultProperties(t *testing.T) {
	want := []struct {
		name     string
		location []string
	}{
		{
			"nestedReadOnlyStringWithDefault",
			[]string{"topLevelObject", "nestedReadOnlyStringWithDefault"},
		},
		{
			"topLevelReadOnlyStringWithDefault",
			[]string{"topLevelReadOnlyStringWithDefault"},
		},
	}
	schema := Schema{
		Properties: schemas,
	}
	flatSchemaItems := schema.ReadOnlyWithDefaultProperties()
	if len(want) != len(flatSchemaItems) {
		t.Errorf("Unexpected number of properties returned. Wanted: %d, got: %d.", len(want), len(flatSchemaItems))
	}
	for i, fs := range flatSchemaItems {
		if want[i].name != fs.Name {
			t.Errorf("Unexpected schema name. Wanted: %q, got: %q.", want[i].name, fs.Name)
		}
		if !reflect.DeepEqual(want[i].location, fs.Location) {
			t.Errorf("Unexpected schema location. Wanted: %q, got: %q.", want[i].location, fs.Location)
		}
	}
}

func TestTopLevelObjectProperties(t *testing.T) {
	want := []string{
		"topLevelObject",
	}
	schema := Schema{
		Properties: schemas,
	}
	props := schema.TopLevelObjectProperties()
	var keys []string
	for k := range props {
		keys = append(keys, k)
	}
	if !reflect.DeepEqual(want, keys) {
		t.Errorf("Wanted: %v, got: %v.", want, keys)
	}
}

func TestNestedSimpleProperties(t *testing.T) {
	want := []struct {
		name     string
		location []string
	}{
		{
			"deeplyNestedString",
			[]string{"nestedObject", "deeplyNestedString"},
		},
		{
			"nestedArrayWithStringItems",
			[]string{"nestedArrayWithStringItems"},
		},
		{
			"nestedInteger",
			[]string{"nestedInteger"},
		},
		{
			"nestedString",
			[]string{"nestedString"},
		},
	}
	schema := schemas["topLevelObject"]
	flatSchemaItems := schema.NestedSimpleProperties()
	if len(want) != len(flatSchemaItems) {
		t.Errorf("Unexpected number of properties returned. Wanted: %d, got: %d.", len(want), len(flatSchemaItems))
	}
	for i, fs := range flatSchemaItems {
		if want[i].name != fs.Name {
			t.Errorf("Unexpected schema name. Wanted: %q, got: %q.", want[i].name, fs.Name)
		}
		if !reflect.DeepEqual(want[i].location, fs.Location) {
			t.Errorf("Unexpected schema location. Wanted: %q, got: %q.", want[i].location, fs.Location)
		}
	}
}

func TestNestedComplexArrayProperties(t *testing.T) {
	want := []struct {
		name     string
		location []string
	}{
		{
			"nestedArrayWithObjectItems",
			[]string{"topLevelObject", "nestedArrayWithObjectItems"},
		},
		{
			"topLevelArrayWithObjectItems",
			[]string{"topLevelArrayWithObjectItems"},
		},
	}
	schema := Schema{
		Properties: schemas,
	}
	flatSchemaItems := schema.NestedComplexArrayProperties()
	if len(want) != len(flatSchemaItems) {
		t.Errorf("Unexpected number of properties returned. Wanted: %d, got: %d.", len(want), len(flatSchemaItems))
	}
	for i, fs := range flatSchemaItems {
		if want[i].name != fs.Name {
			t.Errorf("Unexpected schema name. Wanted: %q, got: %q.", want[i].name, fs.Name)
		}
		if !reflect.DeepEqual(want[i].location, fs.Location) {
			t.Errorf("Unexpected schema location. Wanted: %q, got: %q.", want[i].location, fs.Location)
		}
	}
}
