OWNER=nielsbohr
IMAGE=migrid-exe-node
TAG=edge

.PHONY: build

all: clean build

build:
	docker build -t $(OWNER)/$(IMAGE):$(TAG) .

clean:
	docker rmi -f $(OWNER)/$(IMAGE):$(TAG)

push:
	docker push ${OWNER}/${IMAGE}:${TAG}
