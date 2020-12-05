# Grafana Dashboard Spec

Schema description documents for [Grafana Dashboard
JSON](https://grafana.com/docs/grafana/latest/reference/dashboard/) and core
panels using the [OpenAPI
Specification](https://github.com/OAI/OpenAPI-Specification).

Also in this repository is a code generator that uses the schema documents to
generate libraries for writing Grafana dashboards as code.

## Repo Layout

### [specs/](./specs)

Human-managed specification YAML files.

#### Style Guide for Spec Files

All properties of an object should be defined alphabetically.

All properties should have a description. This is used for API doc generation.

File names should be in camel case. All files referenced as a schema component
in a `spec.yml` should begin with a capital letter (PascalCase). Files
containing shared schema components like "gridPos" or "threshold" should be
named with a leading underscore.

Each spec directory should have child directories "panels", "targets",
"templates" for organizing schema files. All files should live in those
directories except "Dashboard.yml" and "spec.yml".

If a property's name could be more descriptive in code or it collides with
another name nested in the same object, use the `title` field to indicate what
that object should be called in code. For example, some panels have a top-level
array called `links` and also a nested array called `links`. The top-level array
is referring to [panel
links](https://grafana.com/docs/grafana/latest/linking/panel-links/) while the
nested array is referring to [data
links](https://grafana.com/docs/grafana/latest/linking/data-links/), therefore,
the properties have `title` set to "Panel Link" and "Data Link". The code
generator should use this field instead for deciding method names. Depending on
what the language has set for its object inflection property, this will result
in methods like, `addPanelLink()` and `addDataLink()`.

### [templates/](./templates)

Templates for the code generator. Child directories are named after the language
they contain templates for.

Each language must implement the following templates:

* `main.tmpl`: this is intended to be the "entrypoint" for the generated code.
  It should import all other files or do whatever is necessary to tie everything
  together.
* `dashboard.tmpl`: for generating the dashboard object and file.
* `panel.tmpl`: for generating panel objects and files.
* `target.tmpl`: for generating target objects and files.
* `template.tmpl`: for generating template objects and files.
* `_shared.tmpl`: shared template file available to all other templates. This is
  useful for defining reusable template code for others to share.

[`templates/docs.tmpl`](./templates/docs.tmpl) is an exception because it is
language agnostic. All languages use this template for documentation generation.

#### Style Guide for Templates

Object arrays should have "appender" methods. For example `addLink()` and
`addTarget()`.

Objects nested one level should have "setter" methods with all simple fields as
arguments. For example, `setGridPos()` and `setLegend()`.

If fields need special processing, set them as `readOnly` and implement static
methods for setting them. For example if you need to add an incrementing `id`
field like we do when adding panels to a dashboard.

If a property is `readOnly` and also has a default, set the default as a static
value on the object.

## Code Generator

The code generator is a Go program in this repository. Currently only supported
is Jsonnet for spec 7.0. Use it locally with:

```
go run . 7.0 jsonnet
```

This will produce the generated files in `_gen/7.0/jsonnet/`. Generated files
are updated and committed to the
[\_gen](https://github.com/grafana/dashboard-spec/tree/_gen) branch
after every commit to master. See the [Generated Code](#generated-code) section
for direct links.

## Generated Code

The generated code lives in this repository's [\_gen](https://github.com/grafana/dashboard-spec/tree/_gen) branch.

### Spec Documents

* [7.0/spec.json](https://github.com/grafana/dashboard-spec/blob/_gen/_gen/7.0/spec.json)

### Libraries

* [7.0/jsonnet](https://github.com/grafana/dashboard-spec/tree/_gen/_gen/7.0/jsonnet)
