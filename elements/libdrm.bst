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
- kind: git_tag
  url: freedesktop:mesa/drm.git
  track: main
  ref: libdrm-2.4.113-5-g0bd3e4e94f8270e64c7fd1e361a71da4a1547b1b
