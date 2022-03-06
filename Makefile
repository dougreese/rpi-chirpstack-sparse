.PHONY: submodules build-container run

submodules:
	git submodule init
	git submodule update

build-container:
	./build-container.sh

run:
	./run.sh


