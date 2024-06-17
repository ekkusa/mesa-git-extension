kind: junction

sources:
- kind: git_repo
  url: gitlab:freedesktop-sdk/freedesktop-sdk.git
  track: freedesktop-sdk-23.08.*
  ref: freedesktop-sdk-23.08.20-0-g340e8727a724faa0a29a2ab1c452e6a9cb2e7617
- kind: patch
  path: patches/freedesktop-sdk/patch-config-to-point-to-mesa-git.patch

config:
  options:
    bootstrap_build_arch: "%{arch}"
    target_arch: "%{arch}"
    (?):
    - target_arch == 'i686':
        bootstrap_build_arch: 'x86_64'
    - target_arch == 'arm':
        bootstrap_build_arch: 'aarch64'

  overrides:
    components/meson.bst: meson.bst
    extensions/mesa/libdrm.bst: libdrm.bst
