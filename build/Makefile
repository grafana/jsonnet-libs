.uptodate: Dockerfile
	docker build -t grafana/jsonnet-build:$(shell git rev-parse --short HEAD) .
	touch $@
