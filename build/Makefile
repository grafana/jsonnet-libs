.uptodate: Dockerfile
	docker build -t kausal/public-build:$(shell git rev-parse --short HEAD) .
	touch $@
