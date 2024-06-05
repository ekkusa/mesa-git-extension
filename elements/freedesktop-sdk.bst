kind: junction

sources:
- kind: git_repo
  url: gitlab:freedesktop-sdk/freedesktop-sdk.git
  track: master
  ref: freedesktop-sdk-23.08rc.2-2071-g842e4682f5870e6598024ef072a4827a904536ad
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
    extensions/mesa/libdrm.bst: libdrm.bst
