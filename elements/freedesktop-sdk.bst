kind: junction

sources:
- kind: git_tag
  url: gitlab:freedesktop-sdk/freedesktop-sdk.git
  track: 'release/20.08'
  track-tags: true
  submodules:
    utils/buildstream-abi-checker:
      url: gitlab:freedesktop-sdk/buildstream-abi-checker.git
      checkout: false
  ref: freedesktop-sdk-20.08.8-0-gfbcc9f667d93cb5f106e1bd3ed535f6d0c88f76a
- kind: patch
  path: patches/freedesktop-sdk/mesa-extension-prefix.patch

config:
  options:
    bootstrap_build_arch: "%{arch}"
    target_arch: "%{arch}"
    (?):
    - target_arch == 'i686':
        bootstrap_build_arch: 'x86_64'
    - target_arch == 'arm':
        bootstrap_build_arch: 'aarch64'
