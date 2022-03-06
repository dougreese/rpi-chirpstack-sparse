#!/bin/bash

CORES=$(nproc)

if [ ! -d $(pwd)/os-build/layers ]; then
    mkdir -p $(pwd)/os-build/layers
fi

if [ ! -d $(pwd)/os-build/build ]; then
    mkdir -p $(pwd)/os-build/build
fi

docker run --cpus="${CORES}" -it \
    -v $(pwd)/os-build/build:/home/${USER}/os-build/build \
    -v $(pwd)/os-build/layers:/home/${USER}/os-build/layers \
    -v ~/.ssh:/home/${USER}/.ssh \
    rpi-os-builder /bin/bash

