kind: meson
description: libdrm

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst

depends:
- freedesktop-sdk.bst:bootstrap-import.bst
- freedesktop-sdk.bst:components/xorg-lib-pciaccess.bst
- freedesktop-sdk.bst:components/libdrm.bst

(@):
- freedesktop-sdk.bst:elements/extensions/mesa/config.yml

variables:
  meson-local: >-
    -Detnaviv=enabled
    -Dtegra=enabled
    -Dcairo-tests=disabled
    -Dvalgrind=disabled
    -Dman-pages=disabled
    -Dudev=false

public:
  bst:
    split-rules:
      devel:
        (>):
        - '%{libdir}/libdrm_*.so'

sources:
- kind: git_repo
  url: freedesktop:mesa/drm.git
  track: libdrm-*
  ref: libdrm-2.4.122-0-gad78bb591d02162d3b90890aa4d0a238b2a37cde
