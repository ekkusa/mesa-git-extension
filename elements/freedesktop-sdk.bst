kind: junction

sources:
- kind: git_tag
  url: gitlab:freedesktop-sdk/freedesktop-sdk.git
  track: master
  ref: 21.08-branchpoint-1633-gf31e961f3ef7b9867ae8c3340931786aa740bc3d
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
