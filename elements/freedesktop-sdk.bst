kind: junction

sources:
- kind: git_tag
  url: gitlab:freedesktop-sdk/freedesktop-sdk.git
  track: 'master'
  track-tags: false
  submodules:
    utils/buildstream-abi-checker:
      url: gitlab:freedesktop-sdk/buildstream-abi-checker.git
      checkout: False
  ref: freedesktop-sdk-19.08beta.9-955-gdfb3b83a9ffb4c74451354f5c5b607b158cc0f41

config:
  options:
    bootstrap_build_arch: "%{arch}"
    target_arch: "%{arch}"
    (?):
    - target_arch == 'i686':
        bootstrap_build_arch: 'x86_64'
    - target_arch == 'arm':
        bootstrap_build_arch: 'aarch64'
