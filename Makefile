OWNER=nielsbohr
IMAGE=migrid-exe-node
TAG=edge
DEV_MODE=1

.PHONY: build

all: clean build

build:
	docker build --build-arg DEV_MODE=$(DEV_MODE) -t $(OWNER)/$(IMAGE):$(TAG) .

clean:
	docker rmi -f $(OWNER)/$(IMAGE):$(TAG)

push:
	docker push ${OWNER}/${IMAGE}:${TAG}
