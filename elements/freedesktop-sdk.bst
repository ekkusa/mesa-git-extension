kind: junction

sources:
- kind: git_repo
  url: gitlab:freedesktop-sdk/freedesktop-sdk.git
  track: master
  ref: freedesktop-sdk-23.08rc.2-1836-g8993dd580429f2930eae88ba29e05fae6f693fc5
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
