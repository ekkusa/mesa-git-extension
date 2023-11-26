# mesa-git-extension

## Building and installing locally
### Installing dependencies
If you want to test your changes locally, then you will need to first install [BuildStream](https://buildstream.build). The installation instructions can be found [here](https://buildstream.build/install.html). Note that we use the latest version of BuildStream, so ensure you use this version too (otherwise you may not hit our cache server, and have to build everything from scratch). At the time of writing, we use a pre-release snapshot of BuildStream 2.

> **Note**: Since the change to BuildStream 2 we don't require bst-external anymore.

You will also need to have ostree, make, and the usual assortment of development tools installed.

### Building

```shell
# Clone this git repository
git clone https://gitlab.com/freedesktop-sdk/mesa-git-extension.git
cd mesa-git-extension

# Checkout the branch of the version you want to build (22.08 in this example)
git checkout release/22.08

# Build Flatpak runtimes for x86_64 and i686 architectures
make export-repo ARCH=x86_64 REPO=repo/22.08/x86_64
make export-repo ARCH=i686 REPO=repo/22.08/i686
```

### Installing

```shell
# To install a local version, you must first uninstall any previously installed version
flatpak uninstall org.freedesktop.Platform.GL.mesa-git org.freedesktop.Platform.GL32.mesa-git

# Install for both the x86_64 and i686 architectures
flatpak install ./repo/22.08/x86_64 org.freedesktop.Platform.GL.mesa-git
flatpak install ./repo/22.08/i686 org.freedesktop.Platform.GL32.mesa-git
```

### Usage
To use the mesa-git extension, you must set the environment variable `FLATPAK_GL_DRIVERS=mesa-git` before running a Flatpak app. See more details in the [Wiki page](https://gitlab.com/freedesktop-sdk/freedesktop-sdk/-/wikis/mesa-git).

```shell
FLATPAK_GL_DRIVERS=mesa-git flatpak run APP_ID
```
