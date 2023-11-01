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
  track: main
  ref-format: git-describe
  ref: libdrm-2.4.117-20-ga0b011439d44e7d79ffed6dd2d372e60dc7f3b1b
