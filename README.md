## Using

### Build the container used to build the image

```
./build-container.sh
```

### Build the image

Enter the container:

```
./run.sh
```

Inside the container:

```
. layers/poky/oe-init-build-env
```

The `build` directory should now be the current directory.

The `MACHINE` set in `local.conf` is set to `raspberypi4-64`. Change it if necessary. Then build:

```
bitbake core-image-base
```

## How this was set up

This repo is set up to use the Yocto 3.4 (honister) release.  These are the steps used to set up the build. Change `honister` in the submodule commands below if you want to use a different release.

### Build the container used to build the image

```
./build-container.sh
```

The container is built with the current `$USER` as the user inside the container.

### Use the container to build the proper subdirectories

The `run.sh` script enters the container with the proper volume shares.

```
./run.sh
```

Exit the container.

### Add all layers as submodules

#### Standard dependencies

Add the standard layers for the `meta-raspberrypi` build.

```
git submodule add -b honister git://git.yoctoproject.org/poky os-build/layers/poky
git submodule add -b honister git://git.openembedded.org/meta-openembedded os-build/layers/meta-openembedded
git submodule add -b honister git@github.com:agherzan/meta-raspberrypi.git os-build/layers/meta-raspberrypi
```

Add `meta-clang`, which is a dependency of the `chirpstack-concentratord` recipe.

```
git submodule add -b honister git@github.com:kraj/meta-clang.git os-build/layers/meta-clang
```

#### Chirpstack recipes

##### Sparse checkout

Add the entire `chirpstack-gateway-os` as a submodule, which we will change to a sparse checkout. The repo is added to an additional custom layer so the layer config can be set correctly.

```
git submodule add git@github.com:brocaar/chirpstack-gateway-os.git os-build/layers/meta-chirpstack/chirpstack
```

Sparse checkout:

```
cd os-build/layers/meta-chirpstack/chirpstack/
git config core.sparsecheckout true
echo meta/recipes-chirpstack >> ../../../../.git/modules/os-build/layers/meta-chirpstack/chirpstack/info/sparse-checkout
echo meta/recipes-semtech >> ../../../../.git/modules/os-build/layers/meta-chirpstack/chirpstack/info/sparse-checkout
git read-tree -mu HEAD
```

The directory `os-build/layers/meta-chirpstack/chirpstack` will now contain only the `meta/recipes-chirpstack` and `meta-recipes-semtech` directories.

##### Chirpstack layer configuration

Add a file `os-build/layres/meta-chirpstack/conf/layer.conf` with the following contents:

```
BBPATH .= ":${LAYERDIR}"

# We have recipes-* directories, add to BBFILES
BBFILES += "${LAYERDIR}/chirpstack/meta/recipes-*/*/*.bb \
            ${LAYERDIR}/chirpstack/meta/recipes-*/*/*.bbappend"

BBFILE_COLLECTIONS += "meta-chirpstack"
BBFILE_PATTERN_meta-chirpstack = "^${LAYERDIR}/"
BBFILE_PRIORITY_meta-chirpstack = "6"

LAYERDEPENDS_meta-chirpstack = "core"
LAYERSERIES_COMPAT_meta-chirpstack = "hardknott honister"
```

