kind: meson
description: libdrm

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst

depends:
- freedesktop-sdk.bst:bootstrap-import.bst
- freedesktop-sdk.bst:components/xorg-lib-pciaccess.bst
- freedesktop-sdk.bst:components/libdrm.bst

variables:
  prefix: "/usr/lib/%{gcc_triplet}/GL/mesa-git"
  lib: "lib"
  debugdir: "/usr/lib/debug"

  meson-local: >-
    -Detnaviv=true
    -Dtegra=true
    -Dudev=false
    -Dlibdrm=false
    -Dlibkms=false

public:
  bst:
    split-rules:
      devel:
        (>):
        - '%{libdir}/libdrm_*.so'

sources:
- kind: git_tag
  url: freedesktop:mesa/drm.git
  track: master
  # Currently backends from master are not compatible with the last
  # release of libdrm. We need to wait for a release and an update
  # of components/libdrm.bst before uncommenting the following.
  #track-tags: false
  ref: libdrm-2.4.102-0-gbb70ab82fd599b0a0db3d22354f05ae87fbc4515
- kind: patch
  path: patches/libdrm/libdrm_disable_libdrm.patch
