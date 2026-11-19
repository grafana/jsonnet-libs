include ../Makefile_mixin

test: tests/no_response_rules.json

tests/no_response_rules.json: tests/no_response_rules.jsonnet $(wildcard *.libsonnet) $(wildcard signals/*)
	jsonnet -J vendor $< > $@
