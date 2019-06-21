.PHONY: version build push

include .version

version:
	@echo "Using bumpversion"
	bumpversion patch

build:
	@echo "Building revolutionsytems/concourse-dcind:${IMAGE_TAG}..."
	docker build -t revolutionsystems/concourse-dcind:${IMAGE_TAG} .

push:
	docker push revolutionsystems/concourse-dcind:${IMAGE_TAG}
	docker push revolutionsystems/concourse-dcind:latest
