kind: junction

sources:
- kind: git_repo
  url: gitlab:freedesktop-sdk/freedesktop-sdk.git
  track: master
  ref-format: git-describe
  ref: freedesktop-sdk-23.08rc.2-704-gf6d2815ddbd13854085437ab1009296aa7ba5d34
- kind: patch
  path: patches/freedesktop-sdk/patch-config-to-point-to-mesa-git.patch
- kind: patch
  path: patches/freedesktop-sdk/patch-meson-use-newer.patch

config:
  options:
    bootstrap_build_arch: "%{arch}"
    target_arch: "%{arch}"
    (?):
    - target_arch == 'i686':
        bootstrap_build_arch: 'x86_64'
    - target_arch == 'arm':
        bootstrap_build_arch: 'aarch64'
