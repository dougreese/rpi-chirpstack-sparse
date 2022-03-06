.PHONY: submodules build-container run

chirp = os-build/layers/meta-chirpstack/chirpstack/

submodules:
	git submodule init
	git submodule update
	cd $(chirp) && git config core.sparsecheckout true
	cd $(chirp) && echo meta/recipes-chirpstack >> ../../../../.git/modules/os-build/layers/meta-chirpstack/chirpstack/info/sparse-checkout
	cd $(chirp) && echo meta/recipes-semtech >> ../../../../.git/modules/os-build/layers/meta-chirpstack/chirpstack/info/sparse-checkout
	cd $(chirp) && git read-tree -mu HEAD

build-container:
	./build-container.sh

run:
	./run.sh


