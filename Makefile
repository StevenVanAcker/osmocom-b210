cn := osmocom-b210

build:
	docker build --build-arg UBUNTU_VERSION=19.10 -t $(cn) .

shell:
	docker run --rm -ti --privileged -v $$PWD:/data -v /dev:/dev $(cn) /bin/bash

run:
	docker run --rm -ti --privileged -v $$PWD:/data -v /dev:/dev $(cn)
