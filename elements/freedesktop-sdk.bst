kind: junction

sources:
- kind: git_repo
  url: gitlab:freedesktop-sdk/freedesktop-sdk.git
  track: freedesktop-sdk-23.08.*
  ref: freedesktop-sdk-23.08.21-0-gb74caa1b214da1f15cc278327d7806ebcae726a2
- kind: patch
  path: patches/freedesktop-sdk/patch-config-to-point-to-mesa-git.patch
- kind: patch
  path: patches/freedesktop-sdk/0001-components-rust-Enable-more-tools.patch

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
    extensions/mesa/libdrm.bst: libdrm.bst
    components/meson.bst: meson.bst
